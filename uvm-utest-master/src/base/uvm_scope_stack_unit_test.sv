`include "svunit_defines.svh"
`include "test_defines.sv"

import uvm_pkg::*;
import svunit_pkg::*;

`define SET_CAN_START_WITH_BRACKET(NAME,CHAR) \
  `SVTEST(WARNING_set_can_start_with_a_``NAME``bracket) \
    string s_exp = {CHAR,"element0"}; \
    uut.set({CHAR,"element0"}); \
    `FAIL_IF(uut.get() != s_exp); \
  `SVTEST_END

module uvm_scope_stack_unit_test;

  string name = "uvm_scope_stack_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're
  // running the Unit Tests on
  //===================================
  uvm_scope_stack uut;


  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);
  endfunction


  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    svunit_ut.setup();

    uut = new();
  endtask


  //===================================
  // Here we deconstruct anything we
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
    /* Place Teardown Code Here */
  endtask


  //===================================
  // All tests are defined between the
  // SVUNIT_TESTS_BEGIN/END macros
  //
  // Each individual test must be
  // defined between `SVTEST(_NAME_)
  // `SVTEST_END
  //
  // i.e.
  //   `SVTEST(mytest)
  //     <test code>
  //   `SVTEST_END
  //===================================
  `SVUNIT_TESTS_BEGIN

  //-----------------------------
  //-----------------------------
  // depth tests
  //-----------------------------
  //-----------------------------

  `SVTEST(depth_at_construction_is_empty)
    `FAIL_IF(uut.depth() != 0);
  `SVTEST_END


  `SVTEST(depth_returns_stack_depth)
    uut.down("element");
    uut.down_element("20");
    `FAIL_IF(uut.depth() != 2);
  `SVTEST_END

  //-----------------------------
  //-----------------------------
  // get tests
  //-----------------------------
  //-----------------------------

  `SVTEST(get_from_empty_stack_and_no_arg_returns_null)
    `FAIL_IF(uut.get() != _NULL_STRING);
  `SVTEST_END


  `SVTEST(get_from_empty_stack_returns_set_arg)
    string s_exp = "set_arg";
    uut.set_arg(s_exp);
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END


  `SVTEST(get_with_1_element_in_stack_and_no_set_arg)
    string s_exp = "element0";
    uut.set(s_exp);
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END


  `SVTEST(get_with_1_element_in_stack_and_set_arg)
    string s_exp = "element0.set_arg";
    uut.set("element0");
    uut.set_arg("set_arg");
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END


  `SVTEST(get_with_null_string_in_stack_and_set_arg)
    string s_exp = "set_arg";
    uut.set(_NULL_STRING);
    uut.set_arg("set_arg");
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END


  `SVTEST(cannot_set_arg_to_null)
    string s_exp = "jokes";
    uut.set_arg(s_exp);
    uut.set_arg(_NULL_STRING);
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END


  `SVTEST(unset_if_arg_matches)
    string s_exp = "jokes";
    uut.set_arg(s_exp);
    uut.unset_arg(s_exp);
    `FAIL_IF(uut.get() != _NULL_STRING);
  `SVTEST_END


  `SVTEST(dont_unset_if_arg_doesnt_match)
    string s_exp = "jokes";
    uut.set_arg(s_exp);
    uut.unset_arg("hazard");
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END


  `SVTEST(set_arg_element)
    string s_exp = "jokes[50]";
    uut.set_arg_element("jokes", 50);
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END


  `SVTEST(WARNING_can_set_arg_element_without_arg)
    string s_exp = "[50]";
    uut.set_arg_element("", 50);
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END

  //-----------------------------
  //-----------------------------
  // get arg tests
  //-----------------------------
  //-----------------------------

  `SVTEST(scope_arg_null_at_construction)
    `FAIL_IF(uut.get_arg() != _NULL_STRING);
  `SVTEST_END


  `SVTEST(get_arg)
    string s_exp = "jokes";
    uut.set_arg(s_exp);
    `FAIL_IF(uut.get_arg() != s_exp);
  `SVTEST_END

  //-----------------------------
  //-----------------------------
  // set tests
  //-----------------------------
  //-----------------------------

  `SVTEST(set_initialized_the_stack)
    string s_exp = "element1";
    uut.set("element0");
    uut.set("element1");
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END

  `SET_CAN_START_WITH_BRACKET(square,"[")
  `SET_CAN_START_WITH_BRACKET(para,"(")
  `SET_CAN_START_WITH_BRACKET(curly,"{")

  //-----------------------------
  //-----------------------------
  // down tests
  //-----------------------------
  //-----------------------------

  `SVTEST(down_appends_to_stack)
    string s_exp = "element0";
    uut.down("element0");
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END


  `SVTEST(multiple_elements_on_stack_are_concatenated)
    string s_exp = "element0.element1.element2";
    uut.down("element0");
    uut.down("element1");
    uut.down("element2");
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END


  `SVTEST(WARNING_down_can_start_with_any_bracket)
    string s_exp = "[element0(element1{element2";
    uut.down("[element0");
    uut.down("(element1");
    uut.down("{element2");
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END


  `SVTEST(WARNING_down_can_be_empty_string)
    string s_exp = "..";
    uut.down("");
    uut.down("");
    uut.down("");
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END

  //-----------------------------
  //-----------------------------
  // down element tests
  //-----------------------------
  //-----------------------------

  `SVTEST(down_elements_are_concatenated_to_elements)
    string s_exp = "element0[1].element1[0].element2[55]";
    uut.down("element0");
    uut.down_element(1);
    uut.down("element1");
    uut.down_element(0);
    uut.down("element2");
    uut.down_element(55);
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END


  `SVTEST(WARNING_down_elements_can_be_concatenated)
    string s_exp = "[1][0][55]";
    uut.down_element(1);
    uut.down_element(0);
    uut.down_element(55);
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END

  //-----------------------------
  //-----------------------------
  // up element tests
  //-----------------------------
  //-----------------------------
  `SVTEST(up_element_removes_a_down_element)
    string s_exp = "element0";
    uut.down("element0");
    uut.down_element(8);
    uut.up_element();
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END


  `SVTEST(up_element_removes_a_down_element_when_multiple_elements_on_the_stack)
    string s_exp = "element0.element1";
    uut.down("element0");
    uut.down("element1");
    uut.down_element(8);
    uut.up_element();
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END


  `SVTEST(up_element_removes_two_down_elements_when_multiple_elements_on_the_stack)
    string s_exp = "element0";
    uut.down("element0");
    uut.down_element(3);
    uut.down_element(8);
    uut.up_element();
    uut.up_element();
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END


  `SVTEST(up_element_doesnt_remove_a_down)
    string s_exp = "element0";
    uut.down("element0");
    uut.up_element();
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END


  `SVTEST(WARNING_up_element_removes_a_down_that_starts_with_a_bracket)
    string s_exp = "";
    uut.down("[element0");
    uut.up_element();
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END


  `SVTEST(up_element_has_no_effect_on_empty_stack)
    string s_exp = "element0";
    uut.up_element();
    uut.down("element0");
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END

  //-----------------------------
  //-----------------------------
  // up tests
  //-----------------------------
  //-----------------------------

  `SVTEST(up_removes_a_down)
    string s_exp = "element0";
    uut.down("element0");
    uut.down("element1");
    uut.up();
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END


  `SVTEST(WARNING_up_removes_a_down_and_down_element)
    string s_exp = "";
    uut.down("element1");
    uut.down_element("20");
    uut.up();
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END


  `SVTEST(up_removes_empty_strings)
    string s_exp = "element0.element1";
    uut.down("element0");
    uut.down("element1");
    uut.down("");
    uut.up();
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END


  `SVTEST(WARNING_up_treats_elements_starting_with_any_bracket_as_down_elements)
    string s_exp = "";
    uut.down("element0");
    uut.down("[element1");
    uut.down("(element2");
    uut.down("{element3");
    uut.down_element("20");
    uut.up();
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END


  `SVTEST(WARNING_up_removes_multiple_down_elements)
    string s_exp = "";
    uut.down_element("20");
    uut.down_element("30");
    uut.down_element("40");
    uut.down_element("50");
    uut.down_element("60");
    uut.down_element("70");
    uut.up();
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END


  `SVTEST(WARNING_a_separator_other_than_period_makes_no_sense)
    string s_exp = "";
    uut.down("/element0");
    uut.down("element1");
    uut.up("/");
    `FAIL_IF(uut.get() != s_exp);
  `SVTEST_END


  `SVUNIT_TESTS_END

endmodule
