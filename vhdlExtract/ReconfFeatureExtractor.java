import java.io.IOException;
import java.io.PrintStream;
import java.util.Arrays;
import java.util.Locale;

import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;

public class ReconfFeatureExtractor extends vhdl_parserBaseListener {
	public EntityHierarchyBuilder ehb;
	ArchData adata;
	ComponentInstantiationData compInstData;
	
	@Override
	public void exitEntity_declaration(vhdl_parser.Entity_declarationContext ctx) {
		//System.err.println("New entity declaration: " + ctx.identifier(0).getText());
		if (ctx.identifier().size() == 2)
			//System.err.println("With enclosing label: " + ctx.identifier(1).getText());
		
		//System.err.println();
		
		ehb.putEntity(new EntityData(ctx.identifier(0).getText()));
	}
	
	@Override
	public void enterArchitecture_body(vhdl_parser.Architecture_bodyContext ctx) {
		adata = new ArchData();
	}
	
	@Override
	public void exitArchitecture_body(vhdl_parser.Architecture_bodyContext ctx) {
		adata.id = ctx.identifier(0).getText();
		adata.parentEntityName = ctx.identifier(1).getText();
		ehb.putArch(adata);
	}

	@Override
	public void exitComponent_instantiation_statement(vhdl_parser.Component_instantiation_statementContext ctx) {
		//System.err.println("New component instantiation with label: "
		//				+ ctx.label_colon().identifier().getText()
		//				+ "and of entity type " + ctx.instantiated_unit().name().getText());
		
		compInstData = new ComponentInstantiationData();
		compInstData.labelName = normalizeIdentifier(ctx.label_colon().identifier());
		compInstData.entityName = ctx.instantiated_unit().name().getText();
		
		parseReconflist(ctx.reconflist());
		//System.err.println();
		
		adata.childEntityNames.add(compInstData);
	}
	
	private void parseReconflist(vhdl_parser.ReconflistContext ctx) {
		//System.err.println("ctx.module_reconf_entry().size(): " + ctx.module_reconf_entry().size());
		for (int i = 0; i < ctx.module_reconf_entry().size(); i++) {
			if (ctx.module_reconf_entry(i) != null) {
				//System.err.println("Detected altmodule: " + ctx.module_reconf_entry(i).identifier().getText());
				compInstData.addReconfModule(ctx.module_reconf_entry(i).identifier().getText());
			}
		}
	}
	
	public ReconfFeatureExtractor() {
		this.ehb = new EntityHierarchyBuilder();
	}
	
	public static String normalizeIdentifier(vhdl_parser.IdentifierContext ic) {
		if (ic.EXTENDED_IDENTIFIER() != null)
			return ic.EXTENDED_IDENTIFIER().getText();
		else
			return ic.BASIC_IDENTIFIER().getText().toLowerCase(Locale.ROOT);
	}
	
	public static void startParse(String topmodule, String[] filepaths) throws IOException {
		ReconfFeatureExtractor rfe = new ReconfFeatureExtractor();
		
		for (int i = 0; i < filepaths.length; i++) {
			vhdl_lexer lexer = new vhdl_lexer(CharStreams.fromFileName(filepaths[i]));
			vhdl_parser parser = new vhdl_parser(new CommonTokenStream(lexer));
			parser.addParseListener(rfe);
			
			parser.design_file();
		}
		
		if (rfe.ehb.build(topmodule)) {
			//System.err.println(rfe.ehb);
					
			PrintStream prSetupTclStream = System.out;
			prSetupTclStream.print("{");
			rfe.ehb.forAnyInBreadthFirstTraversal(new EntityWalkFunction<Boolean>() {
				@Override
				public Boolean call(EntityData inp) {
					for (ComponentInstantiationData cidata : inp.arch.childEntityNames) {
						if (null != cidata.reconfModuleNames) {
							prSetupTclStream.print("{" + cidata.labelName);
							prSetupTclStream.print(" {" + cidata.entityName);
							for (String module : cidata.reconfModuleNames) {
								prSetupTclStream.print(" " + module);
							}
							prSetupTclStream.print("}} ");
						}
					}
					
					return true;
				}
			});
			prSetupTclStream.print("}");
			prSetupTclStream.close();
		}
	}
	
	public static void main(String[] args) {
		boolean debug_mode = false;
		
		try {
			if (debug_mode) {
				//startParse("avg_engine", new String[]{"tests/1/avg_engine.vhd", "tests/1/avg_module_1.vhd", "tests/1/avg_module_2.vhd"});
				startParse("myTopEntity", new String[]{"tests/2/rshiftLEDs.vhd", "tests/2/upcounter.vhd", "tests/2/myTopEntity.vhd",  "tests/2/unrelatedChild_0.vhd", "tests/2/unrelatedChild_1.vhd",  "tests/2/unrelatedTopEntity.vhd",  "tests/2/blinkingLEDs.vhd", "tests/2/lshiftLEDs.vhd", "tests/2/downcounter.vhd"});
				System.exit(0);
			} else {
				if (args.length == 1) {
					System.err.println("Invalid command line usage.\nProvide list of VHDL files to parse as parameters with top-level-file first.\nAborting.");
					System.exit(1);
				} else {
					startParse(args[0], Arrays.copyOfRange(args, 1, args.length));
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
			System.exit(1);
		}
		System.exit(0);
	}
}