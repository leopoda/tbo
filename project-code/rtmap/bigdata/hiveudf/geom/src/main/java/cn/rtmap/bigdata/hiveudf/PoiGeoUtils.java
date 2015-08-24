package cn.rtmap.bigdata.hiveudf;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

import com.vividsolutions.jts.geom.Envelope;
import com.vividsolutions.jts.geom.Geometry;
import com.vividsolutions.jts.io.ParseException;
import com.vividsolutions.jts.io.WKTReader;

public class PoiGeoUtils {
    public Map<PoiMsg, Geometry> geomBuffer = null;
    private Map<Envelope, PoiMsg> rtree = null;
    private WKTReader wktReader = null;

    public PoiGeoUtils() {
        geomBuffer = new HashMap<PoiMsg, Geometry>();
        rtree = new HashMap<>();
        wktReader = new WKTReader();
    }

    public void addGeom(PoiMsg poi) {
        if (poi == null || poi.geo == null) {
            return;
        }
        try {
            Geometry geom = wktReader.read(poi.geo);
            geomBuffer.put(poi, geom);
            Envelope env = geom.getEnvelopeInternal();
            rtree.put(env, poi);
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }

    public PoiMsg pointInPoi(double x, double y, String floor) {
        for (Envelope box : rtree.keySet()) {
            if (!box.contains(x, y)) {
                continue;
            }
            PoiMsg poi = rtree.get(box);
            String currentFloorid = poi.floorid;
            if (!floor.equals(currentFloorid)) {
                continue;
            }
            Geometry geom = geomBuffer.get(poi);
            Geometry point;
            try {
                point = wktReader.read(String.format("POINT(%f %f)", x, y));
            } catch (ParseException e) {
                e.printStackTrace();
                continue;
            }
            if (!geom.contains(point)) {
                continue;
            }
            return poi;
        }
        return null;
    }

    public static class PoiMsg implements Serializable {
        /**
         * @Fields serialVersionUID TODO
         */
        private static final long serialVersionUID = 7677464395429493076L;
        public String buildid;
        public String floorid;
        public String poino;
        public String name;
        public String geo;
        // public String commons;
    }
}
