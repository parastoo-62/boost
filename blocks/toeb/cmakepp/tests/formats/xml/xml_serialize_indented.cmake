function(test)

function(cmake_string_to_xml input)
  return_ref(input)
endfunction()
function(xml_indented)
  # define callbacks for building result
  function(xml_obj_begin_indented)
   # message(PUSH_AFTER "xml_obj_begin_indented(${ARGN})")
    map_tryget(${context} indentation)
    ans(indentation)
    map_append_string(${context} xml "{\n")
    map_append_string(${context} indentation " ")
  endfunction()
  function(xml_obj_end_indented)
    #message(POP "xml_obj_end_indented(${ARGN})")
    map_tryget(${context} indentation)
    ans(indentation)
    string(SUBSTRING "${indentation}" 1 -1 indentation)
    map_set(${context} indentation "${indentation}")
    map_append_string(${context} xml "${indentation}}")

  endfunction()
  function(xml_array_begin_indented)
    #message(PUSH_AFTER "xml_array_begin_indented(${ARGN}) ${context}")
    map_tryget(${context} indentation)
    ans(indentation)
    map_append_string(${context} xml "[\n")
    map_append_string(${context} indentation " ")
    
  endfunction()
  function(xml_array_end_indented)
   # message(POP "xml_array_end_indented(${ARGN}) ${context}")
    map_tryget(${context} indentation)
    ans(indentation)
    string(SUBSTRING "${indentation}" 1 -1 indentation)
    map_set(${context} indentation "${indentation}")
    map_append_string(${context} xml "${indentation}]")
  endfunction()
  function(xml_obj_keyvalue_begin_indented)
   # message("xml_obj_keyvalue_begin_indented(${key} ${ARGN}) ${context}")
    map_tryget(${context} indentation)
    ans(indentation)
    map_append_string(${context} xml "${indentation}\"${map_element_key}\":")
  endfunction()

  function(xml_obj_keyvalue_end_indented)
    #message("xml_obj_keyvalue_end_indented(${ARGN}) ${context}")
    math(EXPR comma "${map_length} - ${map_element_index} -1 ")
    if(comma)
      map_append_string(${context} xml ",")
    endif()
    
    map_append_string(${context} xml "\n")
  endfunction()

  function(xml_array_element_begin_indented)
   # message("xml_array_element_begin_indented(${ARGN}) ${context}")
    map_tryget(${context} indentation)
    ans(indentation)
    map_append_string(${context} xml "${indentation}")
  endfunction()
  function(xml_array_element_end_indented)
   #message("xml_array_element_end_indented(${ARGN}) ${context}")
    math(EXPR comma "${list_length} - ${list_element_index} -1 ")
    if(comma)
      map_append_string(${context} xml ",")
    endif()
    map_append_string(${context} xml "\n")
  endfunction()
  function(xml_literal_indented)
    if(NOT content_length)
      map_append_string(${context} xml "null")
    elseif("_${node}" MATCHES "^_(0|(([1-9][0-9]*)([.][0-9]+([eE][+-]?[0-9]+)?)?)|true|false)$")
      map_append_string(${context} xml "${node}")
    else()
      cmake_string_to_xml("${node}")
      ans(node)
      map_append_string(${context} xml "${node}")
    endif()
    return()
  endfunction()

   map()
    kv(value              xml_literal_indented)
    kv(map_begin          xml_obj_begin_indented)
    kv(map_end            xml_obj_end_indented)
    kv(list_begin         xml_array_begin_indented)
    kv(list_end           xml_array_end_indented)
    kv(map_element_begin  xml_obj_keyvalue_begin_indented)
    kv(map_element_end    xml_obj_keyvalue_end_indented)
    kv(list_element_begin xml_array_element_begin_indented)
    kv(list_element_end   xml_array_element_end_indented)
  end()
  ans(xml_cbs)
  function_import_table(${xml_cbs} xml_indented_callback)

  # function definition
  function(xml_indented)        
    map_new()
    ans(context)
    dfs_callback(xml_indented_callback ${ARGN})
    map_tryget(${context} xml)
    return_ans()  
  endfunction()
  #delegate
  xml_indented(${ARGN})
  return_ans()
endfunction()





obj("{a:'a',b:'b', c:{c:'aa'}}")
ans(o)

xml_indented("${o}")
ans(res)
message("${res}")

endfunction()