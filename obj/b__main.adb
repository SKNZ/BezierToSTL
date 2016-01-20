pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__main.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__main.adb");
pragma Suppress (Overflow_Check);
with Ada.Exceptions;

package body ada_main is
   pragma Warnings (Off);

   E074 : Short_Integer; pragma Import (Ada, E074, "system__os_lib_E");
   E013 : Short_Integer; pragma Import (Ada, E013, "system__soft_links_E");
   E135 : Short_Integer; pragma Import (Ada, E135, "system__fat_flt_E");
   E097 : Short_Integer; pragma Import (Ada, E097, "system__fat_llf_E");
   E019 : Short_Integer; pragma Import (Ada, E019, "system__exception_table_E");
   E061 : Short_Integer; pragma Import (Ada, E061, "ada__io_exceptions_E");
   E170 : Short_Integer; pragma Import (Ada, E170, "ada__numerics_E");
   E119 : Short_Integer; pragma Import (Ada, E119, "ada__strings_E");
   E121 : Short_Integer; pragma Import (Ada, E121, "ada__strings__maps_E");
   E124 : Short_Integer; pragma Import (Ada, E124, "ada__strings__maps__constants_E");
   E045 : Short_Integer; pragma Import (Ada, E045, "ada__tags_E");
   E060 : Short_Integer; pragma Import (Ada, E060, "ada__streams_E");
   E072 : Short_Integer; pragma Import (Ada, E072, "interfaces__c_E");
   E021 : Short_Integer; pragma Import (Ada, E021, "system__exceptions_E");
   E077 : Short_Integer; pragma Import (Ada, E077, "system__file_control_block_E");
   E066 : Short_Integer; pragma Import (Ada, E066, "system__file_io_E");
   E070 : Short_Integer; pragma Import (Ada, E070, "system__finalization_root_E");
   E068 : Short_Integer; pragma Import (Ada, E068, "ada__finalization_E");
   E110 : Short_Integer; pragma Import (Ada, E110, "system__storage_pools_E");
   E151 : Short_Integer; pragma Import (Ada, E151, "system__finalization_masters_E");
   E147 : Short_Integer; pragma Import (Ada, E147, "system__storage_pools__subpools_E");
   E009 : Short_Integer; pragma Import (Ada, E009, "system__secondary_stack_E");
   E141 : Short_Integer; pragma Import (Ada, E141, "ada__strings__unbounded_E");
   E058 : Short_Integer; pragma Import (Ada, E058, "ada__text_io_E");
   E106 : Short_Integer; pragma Import (Ada, E106, "liste_generique_E");
   E082 : Short_Integer; pragma Import (Ada, E082, "vecteurs_E");
   E080 : Short_Integer; pragma Import (Ada, E080, "math_E");
   E078 : Short_Integer; pragma Import (Ada, E078, "courbes_E");
   E108 : Short_Integer; pragma Import (Ada, E108, "courbes__droites_E");
   E112 : Short_Integer; pragma Import (Ada, E112, "normalisation_E");
   E114 : Short_Integer; pragma Import (Ada, E114, "parser_svg_E");
   E169 : Short_Integer; pragma Import (Ada, E169, "stl_E");

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E108 := E108 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "courbes__droites__finalize_spec");
      begin
         F1;
      end;
      E058 := E058 - 1;
      declare
         procedure F2;
         pragma Import (Ada, F2, "ada__text_io__finalize_spec");
      begin
         F2;
      end;
      E141 := E141 - 1;
      declare
         procedure F3;
         pragma Import (Ada, F3, "ada__strings__unbounded__finalize_spec");
      begin
         F3;
      end;
      declare
         procedure F4;
         pragma Import (Ada, F4, "system__file_io__finalize_body");
      begin
         E066 := E066 - 1;
         F4;
      end;
      E151 := E151 - 1;
      E147 := E147 - 1;
      declare
         procedure F5;
         pragma Import (Ada, F5, "system__storage_pools__subpools__finalize_spec");
      begin
         F5;
      end;
      declare
         procedure F6;
         pragma Import (Ada, F6, "system__finalization_masters__finalize_spec");
      begin
         F6;
      end;
      declare
         procedure Reraise_Library_Exception_If_Any;
            pragma Import (Ada, Reraise_Library_Exception_If_Any, "__gnat_reraise_library_exception_if_any");
      begin
         Reraise_Library_Exception_If_Any;
      end;
   end finalize_library;

   procedure adafinal is
      procedure s_stalib_adafinal;
      pragma Import (C, s_stalib_adafinal, "system__standard_library__adafinal");

      procedure Runtime_Finalize;
      pragma Import (C, Runtime_Finalize, "__gnat_runtime_finalize");

   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      Runtime_Finalize;
      s_stalib_adafinal;
   end adafinal;

   type No_Param_Proc is access procedure;

   procedure adainit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Leap_Seconds_Support : Integer;
      pragma Import (C, Leap_Seconds_Support, "__gl_leap_seconds_support");

      procedure Runtime_Initialize (Install_Handler : Integer);
      pragma Import (C, Runtime_Initialize, "__gnat_runtime_initialize");

      Finalize_Library_Objects : No_Param_Proc;
      pragma Import (C, Finalize_Library_Objects, "__gnat_finalize_library_objects");
   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := -1;
      Time_Slice_Value := -1;
      WC_Encoding := 'b';
      Locking_Policy := ' ';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := ' ';
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;
      Leap_Seconds_Support := 0;

      Runtime_Initialize (1);

      Finalize_Library_Objects := finalize_library'access;

      System.Soft_Links'Elab_Spec;
      System.Fat_Flt'Elab_Spec;
      E135 := E135 + 1;
      System.Fat_Llf'Elab_Spec;
      E097 := E097 + 1;
      System.Exception_Table'Elab_Body;
      E019 := E019 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E061 := E061 + 1;
      Ada.Numerics'Elab_Spec;
      E170 := E170 + 1;
      Ada.Strings'Elab_Spec;
      E119 := E119 + 1;
      Ada.Strings.Maps'Elab_Spec;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E124 := E124 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Streams'Elab_Spec;
      E060 := E060 + 1;
      Interfaces.C'Elab_Spec;
      System.Exceptions'Elab_Spec;
      E021 := E021 + 1;
      System.File_Control_Block'Elab_Spec;
      E077 := E077 + 1;
      System.Finalization_Root'Elab_Spec;
      E070 := E070 + 1;
      Ada.Finalization'Elab_Spec;
      E068 := E068 + 1;
      System.Storage_Pools'Elab_Spec;
      E110 := E110 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Storage_Pools.Subpools'Elab_Spec;
      E147 := E147 + 1;
      System.Finalization_Masters'Elab_Body;
      E151 := E151 + 1;
      System.File_Io'Elab_Body;
      E066 := E066 + 1;
      E072 := E072 + 1;
      Ada.Tags'Elab_Body;
      E045 := E045 + 1;
      E121 := E121 + 1;
      System.Soft_Links'Elab_Body;
      E013 := E013 + 1;
      System.Os_Lib'Elab_Body;
      E074 := E074 + 1;
      System.Secondary_Stack'Elab_Body;
      E009 := E009 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      E141 := E141 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E058 := E058 + 1;
      E106 := E106 + 1;
      Vecteurs'Elab_Spec;
      E082 := E082 + 1;
      E080 := E080 + 1;
      Courbes'Elab_Spec;
      E078 := E078 + 1;
      Courbes.Droites'Elab_Spec;
      E108 := E108 + 1;
      E112 := E112 + 1;
      Parser_Svg'Elab_Spec;
      E114 := E114 + 1;
      STL'ELAB_SPEC;
      E169 := E169 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_main");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer
   is
      procedure Initialize (Addr : System.Address);
      pragma Import (C, Initialize, "__gnat_initialize");

      procedure Finalize;
      pragma Import (C, Finalize, "__gnat_finalize");
      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      gnat_argc := argc;
      gnat_argv := argv;
      gnat_envp := envp;

      Initialize (SEH'Address);
      adainit;
      Ada_Main_Program;
      adafinal;
      Finalize;
      return (gnat_exit_status);
   end;

--  BEGIN Object file/option list
   --   /home/sknz/dev/BezierToSTL/obj/liste_generique.o
   --   /home/sknz/dev/BezierToSTL/obj/vecteurs.o
   --   /home/sknz/dev/BezierToSTL/obj/math.o
   --   /home/sknz/dev/BezierToSTL/obj/courbes.o
   --   /home/sknz/dev/BezierToSTL/obj/courbes-droites.o
   --   /home/sknz/dev/BezierToSTL/obj/normalisation.o
   --   /home/sknz/dev/BezierToSTL/obj/parser_svg.o
   --   /home/sknz/dev/BezierToSTL/obj/stl.o
   --   /home/sknz/dev/BezierToSTL/obj/main.o
   --   -L/home/sknz/dev/BezierToSTL/obj/
   --   -L/home/sknz/dev/BezierToSTL/obj/
   --   -L/usr/lib/gcc/x86_64-unknown-linux-gnu/5.3.0/adalib/
   --   -static
   --   -lgnat
--  END Object file/option list   

end ada_main;
