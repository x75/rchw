#!/usr/bin/env python

# vhdlparse.py - Attempt at a simple (pragmatic) VHDL parser
# 2011, 2012 Oswald Berthold
# GPL

# Manifest:
#  - automatically generate entity wrappers
#  - generate documentation / graphs, see also vhdldoc

# History
# - 20120108: V1
#  - generate graphical entity representation for documentation
# - 20110823: V0
#  - initial vhdl parsing and wrapper generation

# TODO
# - FIXME: handle zero input/output entities
# - FIXME: use "IF only" switch for simplified rendering
# - FIXME: parse into AST and XML
# - FIXME: use XSLT on XML for different output formats

from pyparsing import *
import sys, string, re
from optparse import OptionParser
from string import Template

VERSION = 1

def gen_filename(filebase, mode):
    if mode == "wrapgen":
        modestring = "_wrapper.vhd"
    elif mode == "graphdoc":
        modestring = "_graph.tikz"
        
    return string.replace(filebase, ".vhd", modestring)

def read_file_as_string(filename):
    """read filename as string and return"""
    f = open(filename, "r")
    s = f.read()
    f.close()
    return s
    
def read_hdl(vhdfile):
    """Open and read vhdfile into string and return"""
    try:
        f = open(vhdfile, "r")
    except IOError as (errno, strerror):
        print "I/O error({0}): {1}: {2}".format(errno, strerror, vhdfile)
        sys.exit()
    
    vhdstring = f.read()
    f.close()

    # print "vhdfile:", vhdfile
    # print "vhdstring:"
    # print vhdstring
    return vhdstring

def clean_underscore(s):
    """replace underscores with latex compatible string"""
    return re.sub("_", "\_", s)

def parse_hdl(vhdstring):
    entityToken = Keyword("entity", caseless=True).setResultsName("ENT")
    beginToken = Keyword("begin", caseless=True).setResultsName("BEGIN")
    endToken = Keyword("end", caseless=True).setResultsName("END")
    portToken = Keyword("port", caseless=True).setResultsName("PORT")
    genericToken = Keyword("generic", caseless=True).setResultsName("GENERIC")
    mapToken = Keyword("map", caseless=True)
    attributeToken = Keyword("attribute", caseless=True)
    ident = Word(alphas, alphanums + "_")
    ent_ident = ident.setResultsName("ENT_NAME")
    number = Word(nums + ".")
    paren = oneOf("( )")
    oper = oneOf("* + - /")
    punctuation = oneOf("; :")
    direction = oneOf("in out inout")
    vecspec = oneOf("downto upto to")
    wildToken = Word(alphas, alphanums + "_-", punctuation, paren)
    assignToken = Keyword("<=")
    definitionToken = Keyword(":=")
    numberOper = number | (paren + number + oper + ident + paren + oper + number)
    # assignrhs = (ident | (ident + paren + number + paren) | (ident + paren + number + vecspec + number + paren))
    assignrhs = ident + Optional(paren + number + Optional(vecspec + number) + paren)
    assignment = Group(assignrhs + assignToken + SkipTo(punctuation) + punctuation)

    portType = oneOf("unsigned signed std_logic_vector std_logic integer", caseless=True)
    portAggregateTypeDef = paren + \
                           numberOper + \
                           vecspec + \
                           Word(nums) + \
                           paren
    portTypeFull = portType + Optional(portAggregateTypeDef)
    # generics
    rangeToken = Keyword("range", caseless=True)
    genericRange = rangeToken + number + vecspec + number
    genericLine = Group(ident + punctuation + portType + Optional(genericRange) + definitionToken + number + Optional(punctuation))
    genericSpec = ZeroOrMore(genericLine)
    generics = genericToken + paren + genericSpec + paren + punctuation
    
    # number = nums
    portLine = Group(ident + punctuation + direction + portTypeFull + Optional(punctuation))
    portSpec = ZeroOrMore(portLine).setResultsName("PORTSPEC")

    # processes
    procToken = Keyword("process", caseless=True)
    procBeginToken = Optional(ident + punctuation) + procToken + SkipTo(beginToken) + beginToken
    procEndToken = endToken + procToken + Optional(ident) + punctuation
    process = Group(procBeginToken + SkipTo(procEndToken) + procEndToken)

    # instances
    genericMap = genericToken + mapToken + paren + SkipTo(paren) + paren
    instBeginToken = ident + punctuation + ident + Optional(genericMap) + portToken + mapToken + \
                     paren
    instEndToken = paren + punctuation
    instToken = Group(instBeginToken + SkipTo(instEndToken) + instEndToken)

    # architecture
    archToken = Keyword("architecture", caseless=True).setResultsName("ARCH")
    archIdent = ident.setResultsName("ARCH_NAME")
    archAffiliation = oneOf("of is")
    archEntity = ident
    archHeader = SkipTo(beginToken) # ZeroOrMore(wildToken)
    archBodyElems = ZeroOrMore(process|assignment|instToken).setResultsName("ARCH_BODY_ELEM")
    archBody = beginToken + \
               archBodyElems + \
               endToken + Optional(Optional(archToken) + ident) + punctuation # ZeroOrMore(wildToken)
    
    # HDL_ent = Literal("entity") +
    # instantiate parser
    HDL_ent = entityToken + ent_ident + Literal("is") + \
              Optional(generics) + \
              portToken + paren + portSpec + paren + punctuation + \
              endToken + Optional(entityToken) + ident + punctuation

    HDL_arch = (archToken + archIdent + archAffiliation + \
               archEntity + archAffiliation + archHeader + \
               archBody).setResultsName("ARCH_FULL")

    HDL_top = HDL_ent + HDL_arch

    HDL_top.ignore("--" + restOfLine)
    HDL_top.ignore("library" + restOfLine)
    HDL_top.ignore("use" + restOfLine)

    # parse string
    # parseres = HDL_ent.parseString(vhdstring)
    parseres = HDL_top.parseString(vhdstring)
    # print parseres.dump()
    # print "ARCH_BODY_ELEM", parseres.get("ARCH_BODY_ELEM")
    return parseres

def parseres_dump(parseres):
    print type(parseres)
    print parseres
    print parseres.items()
    print parseres.keys()
    # print len(ports), ports
    # print parseres.asDict()
    # print parseres.asXML()
    # print type(HDL_ent)

def parseres_get_portline(parseres):
    return parseres.get("PORTSPEC")

def parseres_get_arch_full(parseres):
    return parseres.get("ARCH_FULL")

def parseres_get_arch_body_elems(parseres):
    return parseres.get("ARCH_BODY_ELEM")

def arch_body_elems_get_subarray(arch_body_elems, type_s):
    r = []
    if type_s.startswith("inst"):
        type_i = 1
    elif type_s.startswith("sig"):
        # type_i = 2
        return r
    elif type_s.startswith("assi"):
        type_i = 3
    elif type_s.startswith("proc"):
        type_i = 4
    else:
        return r
    for elem in arch_body_elems:
        if type_i == 1:
            if elem[1] == ":":
                r.append(elem)
        if type_i == 3:
            if elem[1] == "<=":
                r.append(elem)
        if type_i == 4:
            if elem[0] == "process":
                r.append(elem)
    return r

############################################################
# start constructing the wrapper output file
def write_hdl_wrapper(vhdfile, parseres):
    vhdfile_wrapper = gen_filename(vhdfile, "wrapgen")
    print vhdfile_wrapper

    vhdwrap_header = "-- Generated by vhdlparse " + str(VERSION)
    vhdwrap_header += "\n-- 20110825 oswald berthold"
    vhdwrap_libs = ("library IEEE;", "use IEEE.STD_LOGIC_1164.ALL;")

    f = open(vhdfile_wrapper, "w")
    f.writelines(vhdwrap_header)
    f.write('\n')

    for lib in vhdwrap_libs:
        f.write(lib)
        f.write('\n')
    f.write('\n')

    # gen entity
    ent_name = parseres.get("ENT_NAME")
    ent_name_wrapper = ent_name + "_wrapper"
    ent_name_wrapped = ent_name + "_wrapped"
    ent_name_wrapped_inst = ent_name_wrapped + "_inst"
    ent_s = [
        "entity " + ent_name_wrapper + " is",
        "\tPort (",
        "\t);",
        "end " + "entity " + ent_name_wrapper + ";"
        ]

    ports = parseres_get_portline(parseres)
    i = 0
    for port in ports:
        # print i, port
        ent_s.insert(2+i, "\t\t" + string.join(port))
        i += 1

    for ent_l in ent_s:
        f.write(ent_l)
        f.write("\n")

    f.write("\n")

    # gen architecture
    arch_s = "architecture bhv of " + ent_name_wrapper + " is"
    f.write(arch_s)
    f.write("\n")

    # components
    f.write("-- Components")
    f.write("\n")
    comp_s = [
        "\tcomponent " + parseres.get("ENT_NAME") + "_wrapped",
        "\t\tPort (",
        "\t\t);",
        "\tend component;"
        ]
    i = 0
    for port in ports:
        # print i, port
        comp_s.insert(2+i, "\t\t\t" + string.join(port))
        i += 1
    for comp_l in comp_s:
        f.write(comp_l)
        f.write("\n")
    f.write("\n")

    # signals
    f.write("-- signals")
    f.write("\n")
    signals = []
    for port in ports:
        # print "port: ", port
        re_mo = re.search("clk", port[0], re.I)
        if re_mo == None:
            signals.append("\t" + "signal " + port[0] + "_buf " + port[1] + " " + string.join(port[3:len(port)]))
        else:
            signals.append("\t" + "-- signal " + port[0] + "_buf " + port[1] + " " + string.join(port[3:len(port)]) + " -- no buffer for clocks")

    signals[len(signals)-1] += " ;"
    for signal in signals:
        f.write(signal)
        f.write("\n")
    # body
    f.write("-- body\n")
    f.write("begin")
    f.write("\n")

    # instantiation
    f.write("-- instances")
    f.write("\n")
    inst_s = [
        "\t" + ent_name_wrapped_inst + " : " + ent_name_wrapped,
        "\t\tport map (",
        "\t\t);"
        ]
    i = 0
    for port in ports:
        # print i, port
        # check for clock signal
        re_mo = re.search("clk", port[0], re.I)
        if re_mo == None:
            inst_s.insert(2+i, "\t\t\t" + port[0] + " => " + port[0] + "_buf")
        else:
            inst_s.insert(2+i, "\t\t\t" + port[0] + " => " + port[0])
        i += 1
        
    i = 0
    for inst_l in inst_s:
        f.write(inst_l)
        # check commas in port map
        if (i > 1) and i < (len(inst_s)-2):
            f.write(",")
        f.write("\n")
        i += 1
    f.write("\n")

    # def or process
    f.write("-- struct/process")
    f.write("\n")

    # FIXME: clk'ed or nor clk'ed?
    # registered

    f.write("\t")
    f.write("buf_process: process(clk)")
    f.write("\n")
    f.write("\t")
    f.write("begin")
    f.write("\n")
    f.write("\t\t")
    f.write("if rising_edge(clk) then")
    f.write("\n")

    for port in ports:
        re_mo = re.search("clk", port[0], re.I)
        if re_mo == None:
            if port[2] == "in":
                # print "in"
                f.write("\t\t\t" + port[0] + "_buf" + " <= " + port[0] + " ;")
            elif port[2] == "out":
                # print "out"
                f.write("\t\t\t" + port[0] + " <= " + port[0] + "_buf" + " ;")
            else:
                # print "-- neither"
                pass
            f.write("\n")

    # close register
    f.write("\t\t")
    f.write("end if;")
    f.write("\n")
    f.write("\t")
    f.write("end process;")
    f.write("\n")
    
    # clean up
    arch_end_s = "end bhv ;"
    f.write(arch_end_s)
    f.write("\n")


    f.flush()
    f.close()

def parseres_get_ports(parseres):
    # generate port matrix
    ports = parseres_get_portline(parseres)
    # print ports
    in_ports = []
    out_ports = []
    inout_ports = []
    # 1 make in and out port lists
    for port in ports:
        if port[2] == "in":
            # print "in port"
            in_ports.append(port)
        elif port[2] == "out":
            # print "out port"
            out_ports.append(port)
        elif port[2] == "inout":
            # print "out port"
            in_ports.append(port)
            out_ports.append(port)
            inout_ports.append(port)
    # print in_ports
    # print out_ports
    return [in_ports, out_ports]

def write_hdl_graph(hdlfile, parseres):
    vhdfile_graph = gen_filename(hdlfile, "graphdoc")
    graph_template_s = read_file_as_string("graphics/graph-template.tikz")

    # get port arrays
    (in_ports, out_ports) = parseres_get_ports(parseres)
    
    portmatrix = "blub"
    # 2 loop over lines and fill locations
    i = 0
    ports_str = ""
    while i < max(len(in_ports), len(out_ports)):
        # print "port num", i
        if i < len(in_ports):
            in_port_name = re.sub("_", "\_", in_ports[i][0])
            in_port_line = "\draw[>-] (-1,0) -- (0,0); & \\node (if_in_%s) [if_in] {$%s$}; &\n" % (in_ports[i][0], in_port_name)
        else:
            in_port_line = "& &\n"

        if i < len(out_ports):
            out_port_name = re.sub("_", "\_", out_ports[i][0])
            out_port_line = "\\node (if_out_%s) [if_out] {$%s$}; & \draw[->] (-1,0) -- (0,0); \\\\\n" % (out_ports[i][0], out_port_name)
        else:
            out_port_line = "& \\\\\n"

        # FIXME: make port_line a proper template string
        ports_str = ports_str + in_port_line + out_port_line
        # print ports_str
        i = i+1


    template_dict = {
        "entity": re.sub("_", "\_", parseres.get("ENT_NAME")),
        "ports": ports_str
        }

    # FIXME: detail flag: include entity innards:
    #  - architecture, signals, component instances, processes
    #  - signal assignments
    # FIXME: detail recursion
    
    s = Template(graph_template_s)
    graph_template = s.substitute(template_dict)
    f = open(vhdfile_graph, "w")
    f.write(graph_template)
    f.close()

def write_hdl_graph_ext(hdlfile, parseres):
    """write extended graphics for VHDL entity, including
    component instances, signals and assignments"""
    vhdfile_graph = gen_filename(hdlfile, "graphdoc")
    graph_template_s = read_file_as_string("graphics/graph-template-ext.tikz")
    
    # get port arrays
    (in_ports, out_ports) = parseres_get_ports(parseres)
    # print "in_ports", in_ports

    # (signals, instances, processes, assigments) \
    #           = parseres_get_sipa(parseres)

    arch_full = parseres_get_arch_full(parseres)
    # print "arch_full:", arch_full

    arch_body_elems = parseres_get_arch_body_elems(parseres)
    # print arch_body_elems
    instances = arch_body_elems_get_subarray(arch_body_elems, "instance")
    assignments = arch_body_elems_get_subarray(arch_body_elems, "assign")
    processes = arch_body_elems_get_subarray(arch_body_elems, "processes")
    # print "instances:", instances
    # print "assignments:", assignments
    # print "processes:", processes

    # for elem in arch_body_elems:
    #     print "arch_body_elem:", elem

    # entity input ports
    s1 = Template("   \\node(in_${num}_port) [left=1cm] {}; & \\node(nix) [minimum width=20pt] {}; & \\node(in_${num}_blk) [if_in] {$portname_p}; \\\\\n")
    s2 = Template("\\draw[>-] (in_${num}_port.west) -- (in_${num}_blk);\n")
    in_port_s = ""
    in_port_cons = ""
    num = 0
    for p in in_ports:
        t_dict = {
            "num": num+1,
            "portname": p[0],
            "portname_p": re.sub("_", "\_", p[0])
            }
        # print t_dict1
        in_port_s = in_port_s + s1.substitute(t_dict)
        in_port_cons = in_port_cons + s2.substitute(t_dict)
        num = num + 1

    # entity output ports
    s1 = Template("\\node(out_${num}_blk) [if_out] {$$${portname_p}$$}; & \\node(nix) [minimum width=20pt] {}; & \\node(out_${num}_port) [left=1cm] {}; \\\\\n")
    s2 = Template("\\draw[->] (out_${num}_blk) -- (out_${num}_port.east);\n")
    out_port_s = ""
    out_port_cons = ""
    num = 0
    for p in out_ports:
        t_dict = {
            "num": num+1,
            "portname": p[0],
            "portname_p": re.sub("_", "\_", p[0])
            }
        # print t_dict1
        out_port_s = out_port_s + s1.substitute(t_dict)
        out_port_cons = out_port_cons + s2.substitute(t_dict)
        num = num + 1

    # signals / assignments
    i = 0
    assignments_s = ""
    assign_left = []
    assign_right = []
    for assign in assignments:
        s = Template("\\node (sig_${num}_blk) [if_in,] at(0,${vpos}) {${assign_left_s} = ${assign_right_s}};\n")
        vpos = -6 + (i * 0.5)
        t_dict = {
            "num": i + 1,
            "vpos": vpos,
            "assign_left": assign[0],
            "assign_left_s": re.sub("_", "\_", assign[0]),
            "assign_right_s": re.sub("_", "\_", assign[2]),
            }
        assignments_s = assignments_s + s.substitute(t_dict)
        # print assign
        assign_left.append(assign[0])
        assign_right.append(assign[2])
        i = i + 1
    # print "assign_s", assignments_s, assign_left, assign_right
        
    # components
    in_port_names = []
    for in_port in in_ports:
        in_port_names.append(in_port[0])
    out_port_names = []
    for out_port in out_ports:
        out_port_names.append(out_port[0])
    # print "i/o_port_names:", in_port_names, out_port_names

    inst_in_port_spec_a = []
    inst_out_port_spec_a = []
    for inst in instances:
        # port lists
        inst_in_port_spec_local = []
        inst_out_port_spec_local = []
        # get data from parse results
        if inst[3] == "port":
            # print "no generics!"
            inst_ports = inst[6].split(",\n")
        elif inst[8] == "port":
            # print "with generics!"
            inst_ports = inst[11].split(",\n")
        else:
            # print "no PORTS!"
            continue
        # print inst
        # print "inst_ports", inst_ports
        for inst_port in inst_ports:
            inst_port_spec = inst_port.split("=>")
            inst_in_port_spec = []
            inst_out_port_spec = []
            try:
                inst_port_spec_clean = re.sub("( |,|\n)", "", inst_port_spec[1])
                # print "inst_port_spec_clean:", inst_port_spec_clean
                # print "in_port_names:", in_port_names
                # print "out_port_names:", out_port_names
                try:
                    # print in_port_names, inst_port_spec_clean
                    # check input ports
                    try:
                        idx = in_port_names.index(inst_port_spec_clean)
                        if idx >= 0:
                            inst_in_port_spec.append(inst_port_spec[0])
                            inst_in_port_spec.append(inst_port_spec_clean)
                            inst_in_port_spec.append("in_" + str(idx+1) + "_blk")
                            inst_in_port_spec_local.append(inst_in_port_spec)
                            continue
                    except:
                        # print "no such element"
                        pass

                    # check output ports
                    try:
                        idx = out_port_names.index(inst_port_spec_clean)
                        if idx >= 0:
                            inst_out_port_spec.append(inst_port_spec[0])
                            inst_out_port_spec.append(inst_port_spec_clean)
                            inst_out_port_spec.append("out_" + str(idx+1) + "_blk")
                            inst_out_port_spec_local.append(inst_out_port_spec)
                            continue
                    except:
                        # print "no such element"
                        pass

                    # check assignment lhs
                    try:
                        idx = assign_left.index(inst_port_spec_clean)
                        if idx >= 0:
                            inst_out_port_spec.append(inst_port_spec[0])
                            inst_out_port_spec.append(inst_port_spec_clean)
                            inst_out_port_spec.append("sig_" + str(idx+1) + "_blk")
                            inst_out_port_spec_local.append(inst_out_port_spec)
                            continue
                    except:
                        # print "no such element"
                        pass
                

                    # check assignment rhs
                    i = 0
                    found_spec = False
                    for rhs in assign_right:
                        if rhs.find(inst_port_spec_clean) > -1:
                            if not found_spec:
                                inst_out_port_spec.append(inst_port_spec[0])
                                inst_out_port_spec.append(inst_port_spec_clean)
                                found_spec = True
                            inst_out_port_spec.append("sig_" + str(i+1) + "_blk")
                        i = i + 1
                    inst_out_port_spec_local.append(inst_out_port_spec)
                    # print inst_port_spec
                    # inst_port_spec_local.append(inst_port_spec)
                except:
                    print "index Error", "'", inst_port_spec_clean, "'"

            except:
                # print "no such index"
                pass
            # print "in:",  inst_in_port_spec_local
            # print "out:", inst_out_port_spec_local
        inst_in_port_spec_a.append(inst_in_port_spec_local)
        inst_out_port_spec_a.append(inst_out_port_spec_local)
        # print len(inst_in_port_spec_a), inst_in_port_spec_a
        # print len(inst_out_port_spec_a), inst_out_port_spec_a

    # second pass: write out template
    i = 0
    inst_s = ""
    inst_ports_s = ""
    for inst in instances:
        s = Template("\\node(inst_${num}) [comp_inst] at(0, ${vpos}) {Inst ${inst_name} ${num}};\n\
\matrix(in_ports) []\n\
	at (0,${vpos_mat})\n\
{\n\
  ${instance_ports_s}\
};\n")
        # print "inst:", inst
        # print "inst_in_ports", inst_in_port_spec_a[i]
        # print "inst_out_ports", inst_out_port_spec_a[i]
        j = 0
        inst_ports_s = ""
        s1 = Template("\\node(inst${instnum}_in_${num}_blk) [if_in] {${in_portname}}; & \\node(inst${instnum}_out_${num}_blk) [if_out] {$out_portname}; \\")
        while j < max(len(inst_in_port_spec_a[i]), len(inst_out_port_spec_a[i])):
            # print "port num", j
            if j < len(inst_in_port_spec_a[i]):
                in_port_name = re.sub("_", "\_", inst_in_port_spec_a[i][j][0])
                in_port_line = "\\node(inst%d_in_%d_blk) [if_in] {%s}; & " % (i+1, j+1, in_port_name)
            else:
                in_port_line = " & "

            # print "inst_out_port_spec_a", i, j, len(inst_out_port_spec_a[i]), inst_out_port_spec_a[i][j]
            if j < len(inst_out_port_spec_a[i]) and len(inst_out_port_spec_a[i][j]) > 0:
                out_port_name = re.sub("_", "\_", inst_out_port_spec_a[i][j][0])
                out_port_line = "\\node(inst%d_out_%d_blk) [if_out] {%s}; \\\\\n" % (i+1, j+1, out_port_name)
            else:
                out_port_line = "\\\\\n"

            # t_dict1 = {
            #     "instnum": i + 1,
            #     "num": j + 1,
            #     "in_portname": in_port_name,
            #     "out_portname": out_port_name
            #     }


                # FIXME: make port_line a proper template string
            inst_ports_s = inst_ports_s + in_port_line + out_port_line
            # inst_ports_s = inst_ports_s + s1.substitute(t_dict1)
            j = j + 1
        # print inst_ports_s

        vpos = i * -2.5
        t_dict = {
            "num": i+1,
            "inst_name": clean_underscore(inst[0]),
            "vpos": vpos,
            "vpos_mat": -1 + vpos,
            "instance_ports_s": inst_ports_s
            }
        inst_s = inst_s + s.substitute(t_dict)

        i = i + 1
    # print inst_s
        # extract instance ports
        # determine connection pattern
        # # in-in?
        # # out-out?
        # # assign-in?
        # # out-assign
        
    # processes

    # internal wiring
    conn_from_in = ""
    conn_to_sig = ""
    conn_to_out = ""

    # instance inputs
    i = 0
    for iips_a in inst_in_port_spec_a:
        j = 0
        for port in iips_a:
            # print "port", port
            s = Template("\draw[->] (${sport}.east) .. controls +(0.5,0.) and +(-0.5,-0.) .. (${dport}.west);\n")
            t_dict = {
                "sport": port[2],
                "dport": "inst%d_in_%d_blk" % (i+1, j+1)
                }
            conn_from_in = conn_from_in + s.substitute(t_dict)
            j = j + 1
        # print "iips_a", iips_a
        i = i + 1

    # instance outputs
    i = 0
    for iops_a in inst_out_port_spec_a:
        # print "iops_a", iops_a
        j = 0
        for port in iops_a:
            # print "port", port
            for k in range(len(port)-2):
                s = Template("\draw[->] (${sport}.east) .. controls +(0.5,0.) and +(-0.5,-0.) .. (${dport}.west);\n")
                t_dict = {
                    "sport": "inst%d_out_%d_blk" % (i+1, j+1),
                    "dport": port[2+k],
                }
                conn_to_sig = conn_to_sig + s.substitute(t_dict)
            j = j + 1
        # print "iips_a", iips_a
        i = i + 1

    # print out_ports
    i = 0
    s = Template("\draw[->] (sig_${assign_num}_blk.east)  .. controls +(0.5,0.) and +(-0.5,-0.) .. (out_${out_num}_blk.west);\n")
    for assign in assignments:
        j = 0
        for out_port in out_ports:
            # if in_ports
            if assign[0] == out_port[0]:
                # print "assign",assign[0], out_port[0]
                t_dict = {
                    "assign_num": i + 1,
                    "out_num": j + 1
                }
                conn_to_out = conn_to_out + s.substitute(t_dict)
            j = j + 1
        i = i + 1
        
    # frames

    template_dict = {
        "entity": re.sub("_", "\_", parseres.get("ENT_NAME")),
        "entity_x": -3.4,
        "entity_y": 5,
        "in_port_s": in_port_s.strip(),
        "in_port_cons": in_port_cons.strip(),
        "in_ports_x": -16, #-3,
        "out_port_s": out_port_s.strip(),
        "out_port_cons": out_port_cons.strip(),
        "out_ports_x": 14, # 4,
        "assignments_s": assignments_s,
        "instances_s": inst_s,
        "conn_from_in": conn_from_in,
        "conn_to_sig": conn_to_sig,
        "conn_to_out": conn_to_out,
        }

    # FIXME: detail flag: include entity innards:
    #  - architecture, signals, component instances, processes
    #  - signal assignments
    # FIXME: detail recursion
    
    s = Template(graph_template_s)
    graph_template = s.substitute(template_dict)
    f = open(vhdfile_graph, "w")
    f.write(graph_template)
    f.close()

# greet = Word( alphas ) + "," + Word( alphas ) + "!"
# hello = "blub Hello, World!"
# greet.ignore("blub")
# print hello, "->", greet.parseString( hello )

def main():
    parser = OptionParser(description="Process HDL code, V" + str(VERSION))
    parser.add_option("-m", "--mode", dest="mode",
                      help="set mode: (wrapgen|graphdoc|graphdoc2)", metavar="MODE",
                      default="wrapgen")
    parser.add_option("-f", "--file", dest="hdlfile",
                      help="set hdl file)", metavar="TARGET",
                      default=None)
    parser.add_option("-v", "--verbose", dest="verbose",
                      help="operate verbously", action="store_true",
                      default=True)
    parser.add_option("-q", "--quiet", dest="verbose",
                      help="operate non-verbously", action="store_false",
                      default=False)
    # parser.add_option("-V", "--version", dest="version_req",
    #                   help=")

    (options, args) = parser.parse_args()

    # check for hdl file
    if options.hdlfile == None:
        sys.exit("Please specify and HDL input file")

    # open and read HDL file
    hdl = read_hdl(options.hdlfile)
    if options.verbose:
        print hdl

    # parse the HDL string
    parseres = parse_hdl(hdl)
    if options.verbose:
        # print parseres.asXML()
        # print parseres.asDict()
        print parseres.dump()

    # operate on parse result
    if options.mode == "wrapgen":
        write_hdl_wrapper(options.hdlfile, parseres)
    elif options.mode == "graphdoc":
        write_hdl_graph(options.hdlfile, parseres)
    elif options.mode == "graphdoc2":
        write_hdl_graph_ext(options.hdlfile, parseres)

    # vhdfile = sys.argv[1] # or some such
    # sys.exit()
    return

if __name__ == "__main__":
    sys.exit(main())
