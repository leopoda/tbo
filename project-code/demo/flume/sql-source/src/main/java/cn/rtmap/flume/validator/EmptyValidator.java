package cn.rtmap.flume.validator;

public class EmptyValidator extends Validator {

	@Override
	public boolean validate(Object data) {
		return false;
	}
}
