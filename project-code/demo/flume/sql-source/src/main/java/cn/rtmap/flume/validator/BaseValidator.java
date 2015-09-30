package cn.rtmap.flume.validator;

import java.util.List;
import java.util.Map;

import org.apache.flume.Context;
import org.apache.flume.Event;
import org.apache.flume.interceptor.Interceptor;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class BaseValidator implements Interceptor {
    private static final Logger LOG = LoggerFactory.getLogger(BaseValidator.class);

	// only Builder can build me.
	// private BaseValidator() {}
	
	@Override
	public void initialize() {}
  
  @Override
  public Event intercept(Event event) {

    Map<String, String> headers = event.getHeaders();

    // // example: add / remove headers
    // if (headers.containsKey("lice")) {
    //   headers.put("shampoo", "antilice");
    //   headers.remove("lice");
    // }

    // example: change body
    String body = new String(event.getBody());
    // if (body.contains("injuries")) {
    //   try {
    //     event.setBody("cyborg".getBytes("UTF-8"));
    //   } catch (java.io.UnsupportedEncodingException e) {
    //     LOG.warn(e);
    //     // drop event completely
    //     return null;
    //   }
    // }
    if (!validate(body)) {
		LOG.error("data validation failed: {}", body);
	}
    return event;
  }

    @Override
    public List<Event> intercept(List<Event> events) {
      for (Event event : events) {
        intercept(event);
      }
      return events;
    }

    @Override
    public void close() {}

    public boolean validate(String data) {
		return true;
	}
	
	// public static class Builder implements Interceptor.Builder {
	// 	@Override
	// 	public BaseValidator build() {
	// 		return new BaseValidator();
	// 	}
	// 	
	// 	@Override
	// 	public void configure(Context context) {}
	// }
}