import java.util.ArrayList;
import java.util.List;


public class ArchData {
	public String id;
	
	public String parentEntityName;
	public List<ComponentInstantiationData> childEntityNames;
	
	public EntityData parentEntity;
	public List<EntityData> children;
	
	public ArchData(String id, String parentEntityName) {
		this.id = id;
		this.parentEntityName = parentEntityName; 
		
		childEntityNames = new ArrayList<ComponentInstantiationData>();
		children = new ArrayList<EntityData>();
	}
	
	public ArchData() {
		childEntityNames = new ArrayList<ComponentInstantiationData>();
		children = new ArrayList<EntityData>();
	}
}