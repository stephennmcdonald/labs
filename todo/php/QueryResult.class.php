<?php

class QueryResult
{
	private $result = NULL;
	private $connx = NULL;
	private $numRows = 0;

	public function __construct($result, $connx)
	{
		$this->result = $result;
		$this->connx = $connx;
		$this->numRows = mysql_num_rows($result);
	}

	public function getRow($row = NULL)
	{
		if ( $this->numRows != 0)
		{
			if($row !== NULL and is_numeric($row))
			{
				if(mysql_data_seek($this->result, abs((int)$row)))
				{
				return(mysql_fetch_assoc($this->result));
				}
			}
			else
			{
				return(false);
			}
		}
		else return NULL;
	}

	public function getTable($headers = FALSE, $labels = NULL)
	{
		if( $this->numRows == 0 || !mysql_data_seek($this->result, 0) )
		{
			return(false);
		}

		$table = "<table class='dbresult'>\n";

		if($headers)
		{
			$table .= "<tr>";
			if(is_array($labels))
			{
				foreach($labels as $label)
				{
					$table .= "<th>$label</th>";
				}
			}
			else
			{
				$num = mysql_num_fields($this->result);
				for($ix = 0; $ix < $num; $ix++)
				{
					$table .= "<th>".mysql_field_name($this->result,$ix)."</th>";
				}
			}
			$table .= "</tr>\n";
		}

		while($row = mysql_fetch_row($this->result))
		{
			$table .= "<tr>";
			foreach($row as $val)
			{
			$table .= "<td>$val</td>";
			}
			$table .= "</tr>\n";
		}

		$table .= "</table>\n";
		return($table);
	}

	public function getArray()
	{
		if ( $this->numRows != 0 )
		{
			mysql_data_seek($this->result, 0);
			$data = array();

			while($row = mysql_fetch_assoc($this->result))
			{
			 $data[] = $row;
			}

			return($data);
		}
		else return NULL;
	}

	public function getXml()
	{
		if ( $this->numRows != 0)
		{
			mysql_data_seek($this->result, 0);
			$xml = "<?xml version='1.0' encoding='ISO-8859-1'?>\n<data>\n";
			$count = 1;

			while($row = mysql_fetch_assoc($this->result))
			{
				$xml .= "  <record row='$count'>\n";
				foreach($row as $key => $val)
				{
					$xml .= "    <$key>$val</$key>\n";
				}
				$xml .= "  </record>\n";
				$count++;
			}

			$xml .= "</data>";
			return($xml);
		}
		else return NULL;
	}

	/**
	*  Free this MySQL result
	*  @return boolean
	*/
	public function free()
	{
		return(mysql_free_result($this->result));
	}

	/**
	*  Getter for query result resource ID
	*  @return resource
	*/
	public function getResultId()
	{
		return($this->result);
	}

	/**
	*  Getter for number of result rows
	*  @return integer
	*/
	public function getNumRows()
	{
		return($this->numRows);
	}
}

