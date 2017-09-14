import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class EntityHierarchyBuilder {
	Map<String, EntityData> entityMap;
	Map<String, List<ArchData>> archMap;
	EntityData topEntity;
	
	public void putEntity(EntityData ed) {
		if (null != entityMap.put(ed.entityID, ed)) {
			System.err.println("Multiple entities with identical identifier found: " + ed.entityID + ". Keeping last read entity.");
		}
	}
	
	public void putArch(ArchData ad) {
		List<ArchData> tmp = archMap.get(ad.parentEntityName);
		
		if (null == tmp) {
			tmp = new ArrayList<ArchData>();
			archMap.put(ad.parentEntityName, tmp);
		}
		
		tmp.add(ad);
	}
	
	public boolean build(String topEntityName) {
		//Set new top level entity
		topEntity = entityMap.get(topEntityName);
		if (topEntity == null) {
			System.err.println("Top module " + topEntityName + " not found. Abborting hierachy build phase.");
			return false;
		}
		
		//build hierarchy
		return forAllInBreadthFirstTraversal(inp -> {
			List<ArchData> aents = archMap.get(inp.entityID);
			if (aents.size() > 1)
				System.err.println("Multiple architectures for entity " + inp.entityID + " found. Selecting architecture" + aents.get(0).id + ".");
			ArchData aent = aents.get(0);
			if (aent == null) {
				System.err.println("No architecture for entity " + inp.entityID + " found. Abborting hierachy build phase.");
				return false;
			}
			
			inp.arch = aent;
			aent.parentEntity = inp;
			
			for (int i = 0; i < aent.childEntityNames.size(); i++) {
				EntityData child = entityMap.get(aent.childEntityNames.get(i).entityName);
				if (child == null) {
					//System.err.println("In architecture " + aent.id + " of entity " + inp.entityID + " the referenced component "
					//		+ aent.childEntityNames.get(i).entityName + " could not be found. Abborting hierachy build phase.");
					//System.err.println("EntityMap:");
					//System.err.println(new PrettyPrintingMap<String, EntityData>(entityMap));
					return false;
				}
				
				child.parent = inp;
				aent.children.add(child);
			}
			
			return true;
		});
	}
	
	public String toString() {		
		return this.<String>traverseHierarchyBreadthFirst(new EntityWalkFunction<String>() {
			@Override
			public String call(EntityData inp) {
				String result = inp.entityID + "(";
				for (EntityData child : inp.getChildren()) {
					result += child.entityID + ",";
				}
				result += ")";
				return result;
			}
		}, new OutputProcFunc<String>() {
			String total = "";		
			@Override
			public boolean putValue(String inp) {
				total += inp + "\n\r";
				return true;
			}
			@Override
			public String getFinalResult() {
				return total;
			}
		});
	}
	
	public boolean forAnyInBreadthFirstTraversal(EntityWalkFunction<Boolean> func) {
		return this.<Boolean>traverseHierarchyBreadthFirst(func, new OutputProcFunc<Boolean>() {
			boolean total = false;
			
			@Override
			public boolean putValue(Boolean inp) {
				total |= inp;
				return true;
			}

			@Override
			public Boolean getFinalResult() {
				return total;
			}
		});
	}
	
	public boolean forAllInBreadthFirstTraversal(EntityWalkFunction<Boolean> func) {
		return this.<Boolean>traverseHierarchyBreadthFirst(func, new OutputProcFunc<Boolean>() {
			boolean total = true;
			
			@Override
			public boolean putValue(Boolean inp) {
				total &= inp;
				return total;
			}

			@Override
			public Boolean getFinalResult() {
				return total;
			}
		});
	}
	
	public <T> T traverseHierarchyBreadthFirst(EntityWalkFunction<T> walkfunc, OutputProcFunc<T> ofunc) {
		List<EntityData> entityWorkList = new ArrayList<EntityData>();
		entityWorkList.add(topEntity);
		
		boolean doNextEntity = true;
		
		while (entityWorkList.size() != 0 && doNextEntity) {
			EntityData e = entityWorkList.remove(0);
			doNextEntity = ofunc.putValue(walkfunc.call(e));
			
			entityWorkList.addAll(e.getChildren());
		}
		
		return ofunc.getFinalResult();
	}
	
	public EntityHierarchyBuilder() {
		entityMap = new HashMap<String, EntityData>();
		archMap = new HashMap<String, List<ArchData>>();
		topEntity = null;
	}
}