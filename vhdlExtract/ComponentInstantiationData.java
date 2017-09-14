import java.util.ArrayList;
import java.util.List;

public class ComponentInstantiationData {
	public String entityName;
	public String labelName;
	public List<String> reconfModuleNames;
	
	public void addReconfModule(String name) {
		if (null == reconfModuleNames)
			reconfModuleNames = new ArrayList<String>();
		reconfModuleNames.add(name);
	}
}