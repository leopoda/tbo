package cn.rtmap.bigdata.hiveudf;

import java.io.IOException;
import java.io.InputStream;
import org.apache.hadoop.hive.ql.exec.*;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.commons.io.IOUtils;

import cn.rtmap.bigdata.hiveudf.PoiGeoUtils.PoiMsg;

import java.util.List;
import java.util.HashMap;

public class Geom extends UDF {
	
	private final static String prefix = "/mining/poi_geom";
	private static HashMap<String, PoiGeoUtils>  hMap = new HashMap<String, PoiGeoUtils>();

	private PoiGeoUtils setup(String buildId) throws IOException {
		Configuration conf = new Configuration();
		FileSystem fs = FileSystem.get(conf);
		String path = String.format("%s/%s/poi_data.csv", prefix, buildId);
		
		InputStream ins = fs.open(new Path(path));
		List<String> pois = IOUtils.readLines(ins, "UTF-8");
		
		PoiGeoUtils geoutils = new PoiGeoUtils();
		if (pois != null) {			
			for (String poi : pois) {
	            PoiMsg msg = new PoiMsg();
	            String[] fields = poi.split("\t");
	            msg.name = fields[0];
	            msg.poino = fields[1];
	            msg.floorid = fields[2];
	            msg.geo = String.format("MULTIPOLYGON(((%s)))", fields[5].replace(':', ' '));
	            geoutils.addGeom(msg);
	        }
		}
		
		return geoutils;
	}
	
	public String evaluate(String x, String y, String floor, String buildId) throws IOException {
		PoiGeoUtils geoutil = null;
		if (buildId != null) {
			if (!hMap.containsKey(buildId)) {
				PoiGeoUtils obj = setup(buildId);
				hMap.put(buildId, obj);
			}

			geoutil = (PoiGeoUtils)hMap.get(buildId);
			if (geoutil != null) {
				PoiMsg poi = geoutil.pointInPoi(Double.parseDouble(x), Double.parseDouble(y), floor.trim());
				if (poi != null) {
					return String.format("%s-%s-%s", poi.floorid, poi.poino,poi.name);
				}	
			}
		}
		return null;
	}

//	public static void main(String[] args) throws IOException {
//		Geom g = new Geom();
//		g.evaluate("", "", "", "860100010020300001");
//	}
}
