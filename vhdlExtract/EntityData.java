import java.util.List;

public class EntityData {
	public String entityID;
	public ArchData arch;
	public EntityData parent;
	
	public List<EntityData> getChildren() {
		return arch.children;
	}
	
	public EntityData(String id) {
		this.entityID = id;
	}
	
	public String toString() {
		return entityID;
		
	}
}