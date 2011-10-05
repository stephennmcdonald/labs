package com.google.maps 
{
	import com.google.maps.GridBounds;
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.Map;
	import com.google.maps.MapEvent;
	import com.google.maps.MapMoveEvent;
	import com.google.maps.interfaces.IMap;
	import com.google.maps.interfaces.IProjection;
	import com.google.maps.overlays.Marker;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class MarkerManager 
	{
		public static const DEFAULT_TILE_SIZE:Number 				= 1024;
		public static const DEFAULT_MAX_ZOOM:Number 				= 17;
		public static const DEFAULT_BORDER_PADDING:Number 			= 100;
		public static const MERCATOR_ZOOM_LEVEL_ZERO_RANGE:Number 	= 256;
		
		private var _map:IMap;
		private var _mapZoom:Number;
		private var _maxZoom:Number;
		private var _projection:IProjection;
		private var _trackMarkers:Boolean;
		private var _swPadding:Point;
		private var _nePadding:Point;
		private var _borderPadding:Number;
		private var _gridWidth:Array;
		private var _grid:Array;
		private var _numMarkers:Array;
		private var _shownBounds:GridBounds;
		private var _shownMarkers:Number;
		private var _tileSize:Number;
		
		/**
		 * Creates a new MarkerManager that will show/hide markers on a map.
		 *
		 * @constructor
		 * @param {Map} map The map to manage.
		 * @param {Object} optionsObj A container for optional arguments:
		 *   {Number} maxZoom The maximum zoom level for which to create tiles.
		 *   {Number} borderPadding The width in pixels beyond the map border,
		 *                   where markers should be display.
		 *   {Boolean} trackMarkers Whether or not this manager should track marker
		 *                   movements.
		 */
		public function MarkerManager(map:IMap, maxZoom:Number = DEFAULT_MAX_ZOOM, borderPadding:Number = DEFAULT_BORDER_PADDING, trackMarkers:Boolean = false) 
		{
			_map = map;
			_mapZoom = map.getZoom();
			_projection = map.getCurrentMapType().getProjection();
			
			_tileSize = DEFAULT_TILE_SIZE;
			
			_maxZoom = maxZoom;
			var padding:Number = borderPadding;

			_swPadding = new Point(-padding, padding);
			_nePadding = new Point(padding, -padding);
			_borderPadding = padding;
			
			_gridWidth = new Array();
			
			_grid = new Array();

			_numMarkers = new Array();
			_numMarkers[maxZoom] = 0;
			
			_map.addEventListener(MapMoveEvent.MOVE_END, onMapMoveEnd);
			
			resetManager();
			_shownMarkers = 0;
			
			_shownBounds = getMapGridBounds();
		};
		
		
		/**
		 * Removes all currently displayed markers
		 * and calls resetManager to clear arrays
		 */
		public function clearMarkers():void {
			processAll(_shownBounds, removeOverlay);
			resetManager();
		}
		
		/**
		 * Searches at every zoom level to find grid cell
		 * that marker would be in, removes from that array if found.
		 * Also removes marker with removeOverlay if visible.
		 * @param {GMarker} marker The marker to delete.
		 */
		public function removeMarker(marker:Marker):void {
			var zoom:Number = _maxZoom;
			var changed:Boolean = false;
			var point:LatLng = marker.getLatLng();
			var grid:Point = getTilePoint(point, zoom, new Point(0, 0));
			while (zoom >= 0) {
				var cell:Array = getGridCellNoCreate(grid.x, grid.y, zoom);
				
				if (cell) {
					removeFromArray(cell, marker);
				}
				// For the current zoom we also need to update the map. Markers that no
				// longer are visible are removed from the map. This also lets us keep the count
				// of visible markers up to date.
				if (zoom == _mapZoom) {
					if (isGridPointVisible(grid)) {
						removeOverlay(marker);
						changed = true;
					} 
				}
				grid.x = grid.x >> 1;
				grid.y = grid.y >> 1;
				--zoom;
			}
			if (changed) {
				notifyListeners();
			}
		}
		
		
		/**
		 * Add many markers at once.
		 * Does not actually update the map, just the internal grid.
		 *
		 * @param {Array of Marker} markers The markers to add.
		 * @param {Number} minZoom The minimum zoom level to display the markers.
		 * @param {Number} maxZoom The maximum zoom level to display the markers.
		 */
		public function addMarkers(markers:Array, minZoom:Number, maxZoom:Number = Infinity):void 
		{
			for (var i:Number = markers.length - 1; i >= 0; i--) 
			{
				addMarkerBatch(markers[i], minZoom, maxZoom);
			}
			
			_numMarkers[minZoom] += markers.length;
		}
		
		
		/**
		 * Calculates the total number of markers potentially visible at a given
		 * zoom level.
		 *
		 * @param {Number} zoom The zoom level to check.
		 * @return {Number}
		 */
		public function getMarkerCount(zoom:Number):Number 
		{
			var total:Number = 0;
			for (var z:Number = 0; z <= zoom; z++) 
			{
				total += _numMarkers[z];
			}
			return total;
		};
		
		
		/**
		 * Add a single marker to the map.
		 *
		 * @param {Marker} marker The marker to add.
		 * @param {Number} minZoom The minimum zoom level to display the marker.
		 * @param {Number} maxZoom The maximum zoom level to display the marker.
		 */
		public function addMarker(marker:Marker, minZoom:Number, maxZoom:Number = Infinity):void 
		{
			addMarkerBatch(marker, minZoom, maxZoom);
			var gridPoint:Point = getTilePoint(marker.getLatLng(), _mapZoom, new Point(0, 0));
			if(isGridPointVisible(gridPoint) && minZoom <= _shownBounds.z && _shownBounds.z <= maxZoom ) 
			{
				addOverlay(marker);
				notifyListeners();
			}
			_numMarkers[minZoom]++;
		};
		
		
		
		/**
		 * Refresh forces the marker-manager into a good state.
		 * If never before initialized, shows all the markers.
		 * If previously initialized, removes and re-adds all markers.
		 */
		public function refresh():void {
			if (_shownMarkers > 0) {
				processAll(_shownBounds, removeOverlay);
			}
			processAll(_shownBounds, addOverlay);
			notifyListeners();
		};
		
		
		
		/**
		 * Initializes MarkerManager arrays for all zoom levels
		 * Called by constructor and by clearAllMarkers
		 */ 
		private function resetManager():void 
		{
			var mapWidth:Number = MERCATOR_ZOOM_LEVEL_ZERO_RANGE;
			for (var zoom:Number = 0; zoom <= _maxZoom; ++zoom) 
			{
				_grid[zoom] = new Array();
				_numMarkers[zoom] = 0;
				_gridWidth[zoom] = Math.ceil(mapWidth/_tileSize);
				mapWidth <<= 1;
			}
		}

		
		
		/**
		 * Gets the tile coordinate for a given latlng point.
		 *
		 * @param {LatLng} latlng The geographical point.
		 * @param {Number} zoom The zoom level.
		 * @param {GSize} padding The padding used to shift the pixel coordinate.
		 *               Used for expanding a bounds to include an extra padding
		 *               of pixels surrounding the bounds.
		 * @return {GPoint} The point in tile coordinates.
		 *
		 */
		private function getTilePoint(latlng:LatLng, zoom:Number, padding:Point):Point 
		{
			var pixelPoint:Point = _projection.fromLatLngToPixel(latlng, zoom);
			return new Point( Math.floor((pixelPoint.x + padding.x) / _tileSize), Math.floor((pixelPoint.y + padding.y) / _tileSize));
		};
		
		
		/**
		 * Finds the appropriate place to add the marker to the grid.
		 * Optimized for speed; does not actually add the marker to the map.
		 * Designed for batch-processing thousands of markers.
		 *
		 * @param {Marker} marker The marker to add.
		 * @param {Number} minZoom The minimum zoom for displaying the marker.
		 * @param {Number} maxZoom The maximum zoom for displaying the marker.
		 */
		private function addMarkerBatch(marker:Marker, minZoom:Number, maxZoom:Number):void 
		{
			var mPoint:LatLng = marker.getLatLng();
			// Tracking markers is expensive, so we do this only if the
			// user explicitly requested it when creating marker manager.
			if (_trackMarkers) 
			{
				marker.addEventListener("changed", onMarkerMoved);
			}
			
			var gridPoint:Point = getTilePoint(mPoint, maxZoom, new Point(0, 0));
			
			for (var zoom:Number = maxZoom; zoom >= minZoom; zoom--) 
			{
				var cell:Array = getGridCellCreate(gridPoint.x, gridPoint.y, zoom);
				cell.push(marker);
				
				gridPoint.x = gridPoint.x >> 1;
				gridPoint.y = gridPoint.y >> 1;
			}
		};
		
		
		/**
		 * Returns whether or not the given point is visible in the shown bounds. This
		 * is a helper method that takes care of the corner case, when shownBounds have
		 * negative minX value.
		 *
		 * @param {Point} point a point on a grid.
		 * @return {Boolean} Whether or not the given point is visible in the currently
		 * shown bounds.
		 */
		private function isGridPointVisible(point:Point):Boolean 
		{
			var vertical:Boolean = _shownBounds.minY <= point.y &&
				point.y <= _shownBounds.maxY;
			var minX:Number = _shownBounds.minX;
			var horizontal:Boolean = minX <= point.x && point.x <= _shownBounds.maxX;
			if (!horizontal && minX < 0) 
			{
				// Shifts the negative part of the rectangle. As point.x is always less
				// than grid width, only test shifted minX .. 0 part of the shown bounds.
				var width:Number = _gridWidth[_shownBounds.z];
				horizontal = minX + width <= point.x && point.x <= width - 1;
			}
			return vertical && horizontal;
		}
		
		
		/**
		 * Reacts to a notification from a marker that it has moved to a new location.
		 * It scans the grid all all zoom levels and moves the marker from the old grid
		 * location to a new grid location.
		 *
		 * @param {Marker} marker The marker that moved.
		 * @param {LatLng} oldLatLng The old position of the marker.
		 * @param {LatLng} newLatLng The new position of the marker.
		 */
		private function onMarkerMoved(marker:Marker, oldLatLng:LatLng, newLatLng:LatLng):void 
		{
			// NOTE: We do not know the minimum or maximum zoom the marker was
			// added at, so we start at the absolute maximum. Whenever we successfully
			// remove a marker at a given zoom, we add it at the new grid coordinates.
			var zoom:Number = _maxZoom;
			var changed:Boolean = false;
			var oldGrid:Point = getTilePoint(oldLatLng, zoom, new Point(0, 0));
			var newGrid:Point = getTilePoint(newLatLng, zoom, new Point(0, 0));
			while (zoom >= 0 && (oldGrid.x != newGrid.x || oldGrid.y != newGrid.y)) 
			{
				var cell:Array = getGridCellNoCreate(oldGrid.x, oldGrid.y, zoom);
				if (cell) 
				{
					if (removeFromArray(cell, marker)) 
					{
						getGridCellCreate(newGrid.x, newGrid.y, zoom).push(marker);
					}
				}
				// For the current zoom we also need to update the map. Markers that no
				// longer are visible are removed from the map. Markers that moved into
				// the shown bounds are added to the map. This also lets us keep the count
				// of visible markers up to date.
				if (zoom == _mapZoom) 
				{
					if (isGridPointVisible(oldGrid)) 
					{
						if (!isGridPointVisible(newGrid)) 
						{
							removeOverlay(marker);
							changed = true;
						}
					} 
					else 
					{
						if (isGridPointVisible(newGrid)) 
						{
							addOverlay(marker);
							changed = true;
						}
					}
				}
				
				oldGrid.x = oldGrid.x >> 1;
				oldGrid.y = oldGrid.y >> 1;
				newGrid.x = newGrid.x >> 1;
				newGrid.y = newGrid.y >> 1;
				--zoom;
			}
			if (changed) notifyListeners();
		};
		
		
		/**
		 * Get a cell in the grid, creating it first if necessary.
		 *
		 * Optimization candidate
		 *
		 * @param {Number} x The x coordinate of the cell.
		 * @param {Number} y The y coordinate of the cell.
		 * @param {Number} z The z coordinate of the cell.
		 * @return {Array} The cell in the array.
		 */
		private function getGridCellCreate(x:Number, y:Number, z:Number):Array {
			var grid:Array = _grid[z];
			if (x < 0) {
				x += _gridWidth[z];
			}
			var gridCol:Array = grid[x];
			if (!gridCol) {
				gridCol = grid[x] = [];
				return gridCol[y] = [];
			}
			var gridCell:Array = gridCol[y];
			if (!gridCell) {
				return gridCol[y] = [];
			}
			return gridCell;
		}
		
		
		/**
		 * Get a cell in the grid, returning undefined if it does not exist.
		 *
		 * NOTE: Optimized for speed -- otherwise could combine with getGridCellCreate.
		 *
		 * @param {Number} x The x coordinate of the cell.
		 * @param {Number} y The y coordinate of the cell.
		 * @param {Number} z The z coordinate of the cell.
		 * @return {Array} The cell in the array.
		 */
		private function getGridCellNoCreate(x:Number, y:Number, z:Number):Array {
			var grid:Array = _grid[z];
			if (x < 0) {
				x += _gridWidth[z];
			}
			var gridCol:Array = grid[x];
			return gridCol ? gridCol[y] : undefined;
		};
		
		
		/**
		 * Turns at geographical bounds into a grid-space bounds.
		 *
		 * @param {LatLngBounds} bounds The geographical bounds.
		 * @param {Number} zoom The zoom level of the bounds.
		 * @param {GSize} swPadding The padding in pixels to extend beyond the
		 * given bounds.
		 * @param {GSize} nePadding The padding in pixels to extend beyond the
		 * given bounds.
		 * @return {GBounds} The bounds in grid space.
		 */
		private function getGridBounds(bounds:LatLngBounds, zoom:Number, swPadding:Point, nePadding:Point):GridBounds 
		{
			zoom = Math.min(zoom, _maxZoom);
			
			var bl:LatLng = bounds.getSouthWest();
			var tr:LatLng = bounds.getNorthEast();
			var sw:Point = getTilePoint(bl, zoom, swPadding);
			var ne:Point = getTilePoint(tr, zoom, nePadding);
			var gw:Number = _gridWidth[zoom];
			
			// Crossing the prime meridian requires correction of bounds.
			if (tr.lng() < bl.lng() || ne.x < sw.x) 
			{
				sw.x -= gw;
			}
			
			if (ne.x - sw.x  + 1 >= gw) 
			{
				// Computed grid bounds are larger than the world; truncate.
				sw.x = 0;
				ne.x = gw - 1;
			}
			
			var gridBounds:GridBounds = new GridBounds([sw, ne]);
			gridBounds.z = zoom;
			return gridBounds;
		}
		
		
		/**
		 * Gets the grid-space bounds for the current map viewport.
		 *
		 * @return {Bounds} The bounds in grid space.
		 */
		private function getMapGridBounds():GridBounds 
		{
			return getGridBounds(_map.getLatLngBounds(), _mapZoom, _swPadding, _nePadding);
		}
		
		
		/**
		 * Event listener for map:movend.
		 * NOTE: Use a timeout so that the user is not blocked
		 * from moving the map.
		 *
		 */
		private function onMapMoveEnd(event:MapMoveEvent):void 
		{
			updateMarkers();
		}
		
		
		/**
		 * Call a function or evaluate an expression after a specified number of
		 * milliseconds.
		 *
		 * Equivalent to the standard window.setTimeout function, but the given
		 * function executes as a method of this instance. So the function passed to
		 * objectSetTimeout can contain references to 
		 *    objectSetTimeout(this, function() { alert(x) }, 1000);
		 *
		 * @param {Object} object  The target object.
		 * @param {Function} command  The command to run.
		 * @param {Number} milliseconds  The delay.
		 * @return {Boolean}  Success.
		 */
		/*
		MarkerManager.prototype.objectSetTimeout_ = function(object, command, milliseconds) {
		return window.setTimeout(function() {
		command.call(object);
		}, milliseconds);
		};
		*/
		
		/**
		 * After the viewport may have changed, add or remove markers as needed.
		 */
		private function updateMarkers():void {
			_mapZoom = _map.getZoom();
			var newBounds:GridBounds = getMapGridBounds();
			
			// If the move does not include new grid sections,
			// we have no work to do:
			if (newBounds.equals(_shownBounds) && newBounds.z == _shownBounds.z) {
				return;
			}
			
			if (newBounds.z != _shownBounds.z) {
				processAll(_shownBounds, removeOverlay);
				processAll(newBounds, addOverlay);
			} else {
				// Remove markers:
				rectangleDiff(_shownBounds, newBounds, removeCellMarkers);
				
				// Add markers:
				rectangleDiff(newBounds, _shownBounds, addCellMarkers);
			}
			_shownBounds = newBounds;
			
			notifyListeners();
		};
		
		
		/**
		 * Notify listeners when the state of what is displayed changes.
		 */
		private function notifyListeners():void {
			//dispatchEvent(new Event("changed"), _shownBounds, _shownMarkers);
		}
		
		
		/**
		 * Process all markers in the bounds provided, using a callback.
		 *
		 * @param {Bounds} bounds The bounds in grid space.
		 * @param {Function} callback The function to call for each marker.
		 */
		private function processAll(bounds:GridBounds, callback:Function):void {
			for (var x:int = bounds.minX; x <= bounds.maxX; x++) {
				for (var y:int = bounds.minY; y <= bounds.maxY; y++) {
					processCellMarkers(x, y,  bounds.z, callback);
				}
			}
		}
		
		
		/**
		 * Process all markers in the grid cell, using a callback.
		 *
		 * @param {Number} x The x coordinate of the cell.
		 * @param {Number} y The y coordinate of the cell.
		 * @param {Number} z The z coordinate of the cell.
		 * @param {Function} callback The function to call for each marker.
		 */
		private function processCellMarkers(x:Number, y:Number, z:Number, callback:Function):void {
			var cell:Array = getGridCellNoCreate(x, y, z);
			if (cell) {
				for (var i:int = cell.length - 1; i >= 0; i--) {
					callback(cell[i]);
				}
			}
		};
		
		
		/**
		 * Remove all markers in a grid cell.
		 *
		 * @param {Number} x The x coordinate of the cell.
		 * @param {Number} y The y coordinate of the cell.
		 * @param {Number} z The z coordinate of the cell.
		 */
		private function removeCellMarkers(x:Number, y:Number, z:Number):void {
			processCellMarkers(x, y, z, removeOverlay);
		};
		
		
		/**
		 * Add all markers in a grid cell.
		 *
		 * @param {Number} x The x coordinate of the cell.
		 * @param {Number} y The y coordinate of the cell.
		 * @param {Number} z The z coordinate of the cell.
		 */
		private function addCellMarkers(x:Number, y:Number, z:Number):void {
			processCellMarkers(x, y, z, addOverlay);
		};
		
		
		/**
		 * Use the rectangleDiffCoords function to process all grid cells
		 * that are in bounds1 but not bounds2, using a callback, and using
		 * the current MarkerManager object as the instance.
		 *
		 * Pass the z parameter to the callback in addition to x and y.
		 *
		 * @param {Bounds} bounds1 The bounds of all points we may process.
		 * @param {Bounds} bounds2 The bounds of points to exclude.
		 * @param {Function} callback The callback function to call
		 *                   for each grid coordinate (x, y, z).
		 */
		private function rectangleDiff(bounds1:GridBounds, bounds2:GridBounds, callback:Function):void {
			var me:MarkerManager = this;
			rectangleDiffCoords(bounds1, bounds2, function(x:Number, y:Number):void {
				callback.apply(me, [x, y, bounds1.z]);
			});
		};
		
		
		/**
		 * Calls the function for all points in bounds1, not in bounds2
		 *
		 * @param {Bounds} bounds1 The bounds of all points we may process.
		 * @param {Bounds} bounds2 The bounds of points to exclude.
		 * @param {Function} callback The callback function to call
		 *                   for each grid coordinate.
		 */
		private function rectangleDiffCoords(bounds1:GridBounds, bounds2:GridBounds, callback:Function):void {
			var minX1:Number = bounds1.minX;
			var minY1:Number = bounds1.minY;
			var maxX1:Number = bounds1.maxX;
			var maxY1:Number = bounds1.maxY;
			var minX2:Number = bounds2.minX;
			var minY2:Number = bounds2.minY;
			var maxX2:Number = bounds2.maxX;
			var maxY2:Number = bounds2.maxY;
			
			var x:int;
			var y:int;
			
			for (x = minX1; x <= maxX1; x++) {  // All x in R1
				// All above:
				for (y = minY1; y <= maxY1 && y < minY2; y++) {  // y in R1 above R2
					callback(x, y);
				}
				// All below:
				for (y = Math.max(maxY2 + 1, minY1);  // y in R1 below R2
					y <= maxY1; y++) {
					callback(x, y);
				}
			}
			
			for (y = Math.max(minY1, minY2);
				y <= Math.min(maxY1, maxY2); y++) {  // All y in R2 and in R1
				// Strictly left:
				for (x = Math.min(maxX1 + 1, minX2) - 1;
					x >= minX1; x--) {  // x in R1 left of R2
					callback(x, y);
				}
				// Strictly right:
				for (x = Math.max(minX1, maxX2 + 1);  // x in R1 right of R2
					x <= maxX1; x++) {
					callback(x, y);
				}
			}
		}
		
		
		/**
		 * Removes value from array. O(N).
		 *
		 * @param {Array} array  The array to modify.
		 * @param {any} value  The value to remove.
		 * @param {Boolean} opt_notype  Flag to disable type checking in equality.
		 * @return {Number}  The number of instances of value that were removed.
		 */
		private function removeFromArray(array:Array, value:Object, opt_notype:Boolean = false):Number {
			var shift:int = 0;
			for (var i:int = 0; i < array.length; ++i) {
				if (array[i] === value || (opt_notype && array[i] == value)) {
					array.splice(i--, 1);
					shift++;
				}
			}
			return shift;
		}
		
		
		private function removeOverlay(marker:Marker):void 
		{
			_map.removeOverlay(marker);
			_shownMarkers--;
		}
		
		private function addOverlay(marker:Marker):void 
		{
			_map.addOverlay(marker);
			_shownMarkers++;
		}
	}
}
