package ordt.parameters;

import ordt.extract.Ordt;
import ordt.extract.RegNumber;

public class ExtRegNumberParameter extends ExtParameter<RegNumber> {

	ExtRegNumberParameter(String name, RegNumber value) {
		super(name, value);
	}

	@Override
	public void set(String valStr) {
		RegNumber val = new RegNumber(valStr);
		if (val.isDefined()) {
			this.value = val;
			//System.out.println("ExtParameters.ExtRegNumberParameter : " + name + " = " + valStr + ", resolved to " + val);
		} 
		else Ordt.errorMessage("invalid " + name + " parameter value specified (" + value + ").");
	}

	@Override
	public String toString() {
		return value.toString();
	}

}
