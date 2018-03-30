`include "svunit_defines.svh"
`include "test_uvm_component.sv"

import svunit_pkg::*;
import uvm_pkg::*;


module uvm_component_unit_test;

  string name = "uvm_component_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  test_uvm_component uut;


  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);

    uut = new("test_comp", null);
  endfunction


  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    svunit_ut.setup();
    /* Place Setup Code Here */
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
  // constructor tests
  //-----------------------------
  //-----------------------------
  // TBD


  //-----------------------------
  //-----------------------------
  // get_parent
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // get_full_name
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // get_children
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // get_child
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // get_next_child
  //-----------------------------
  //-----------------------------


  //-----------------------------
  //-----------------------------
  // get_first_child
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // get_num_children
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // has_child
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // set_name
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // lookup
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // get_depth
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // build_phase
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // build
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // connect_phase
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // connect
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // end_of_elaboration_phase
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // end_of_elaboration
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // start_of_simulation_phase
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // start_of_simulation
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // run_phase
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // run
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // pre_reset_phase
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // reset_phase
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // post_reset_phase
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // pre_configure_phase
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // configure_phase
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // post_configure_phase
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // pre_main_phase
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // main_phase
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // post_main_phase
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // pre_shutdown_phase
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // shutdown_phase
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // post_shutdown_phase
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // extract_phase
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // extract
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // check_phase
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // check
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // report_phase
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // report
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // final_phase
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // phase_started
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // phase_ready_to_end
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // phase_ended
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // set_domain
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // get_domain
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // define_domain
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // set_phase_imp
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // suspend
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // resume
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // resolve_bindings
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // massage_scope
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // set_config_int
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // set_config_string
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // set_config_object
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // get_config_int
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // get_config_string
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // get_config_object
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // check_config_usage
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // apply_config_settings
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // print_config_settings
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // print_config
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // print_config_with_audit
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // raised
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // dropped
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // all_dropped
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // create_component
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // create_object
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // set_type_override_by_type
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // set_inst_override_by_type
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // set_type_override
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // set_inst_override
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // print_override_info
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // set_report_id_verbosity_hier
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // set_report_severity_id_verbosity_hier
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // set_report_severity_action_hier
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // set_report_id_action_hier
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // set_report_severity_id_action_hier
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // set_report_default_file_hier
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // set_report_severity_file_hier
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // set_report_id_file_hier
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // set_report_severity_id_file_hier
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // set_report_verbosity_level_hier
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // pre_abort
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // accept_tr
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // do_accept_tr
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // begin_tr
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // begin_child_tr
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // do_begin_tr
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // end_tr
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // do_end_tr
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // record_error_tr
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // record_event_tr
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // m_add_child
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // m_set_full_name
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // do_resolve_bindings
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // do_flush
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // flush
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // m_extract_name
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // create
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // clone
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // m_begin_tr
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // get_type_name
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // do_print
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // m_set_cl_msg_args
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // m_set_cl_verb
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // m_set_cl_action
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // m_set_cl_sev
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // m_apply_verbosity_settings
  //-----------------------------
  //-----------------------------

  //-----------------------------
  //-----------------------------
  // m_do_pre_abort
  //-----------------------------
  //-----------------------------


  `SVUNIT_TESTS_END

endmodule