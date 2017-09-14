# prMagic
Tools for automating the Vivado project partial reconfiguration flow. Developed as part of my bachelor thesis.

# Instructions
1. Download the release package and extract the contents into your Vivado project folder
2. Include all your VHDL files into the project (preferably into the sources_1 file set)
3. Annotate your component instantiations with
```vhdl
--PRMODULE(<modulename>);
```
example:
```vhdl
--PRMODULE(anotherModule01);
--PRMODULE(anotherModule02);
--PRMODULE(anotherModule03);
myRegion01: primaryModule
port map (
  clk => clk,
  A => A,
  Y => Y_i2
);
```
4. Run "source prMagic.tcl" to load scripts
5. Run prm_main now to setup partial reconfiguration
6. Edit code and annotations, go back to 5.
7. Floorplan the partitions
8. Use Vivado as you would normally

# Limitations
* Nothing but VHDL is supported in the hierarchy (no Verilog, IP-blocks, etc.)
* Keep every modules top level entity in a separate file
* Do not use the same entity in different partitions
* No entity instantiations for primary modules of partitions
* Aliases and libraries are not supported for module name resolution
