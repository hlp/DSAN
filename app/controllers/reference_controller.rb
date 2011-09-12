
class ReferenceController < ApplicationController
  before_filter :authenticate

  @@subject_start = "<span class=\"reference-subject\">"
  @@subject_end = "</span>"

  def self.create_var_link(var)
    return "<a href=\"##{var}\">#{var}</a>"
  end

  def self.create_var_string(var)
    str = @@subject_start + var["name"] + @@subject_end
    if var["isa"]
      str += " : " + create_var_link(var["isa"])
    end
    return str
  end

  def self.create_method_string(object)
    str = @@subject_start + object["name"] + @@subject_end
    if object["returns"]
      str += " : " + create_var_link(object["returns"])
    end
    str += " ( "

    if object["parameters"]
      count = 0;
      object["parameters"].each do |param|
        str += create_var_string(param)
        unless count == (object["parameters"].length - 1) 
          str += ", "
        end
        count += 1
      end
    end
    str += " )"
    return str
  end

  def self.get_constructors(object)
    ctors = []
    object["members"].each do |mem|
      if mem["type"].to_s == "constructor"
        meth = mem
        unless meth["name"]
          meth["name"] = object["name"]
        end
        ctors.push(ReferenceController.create_method_string(meth))
      end
    end

    return ctors
  end

  def self.get_sorted_constructors(object)
    return get_constructors(object).sort
  end

  def self.get_methods(object)
    meths = []
    object["members"].each do |mem|
      if mem["type"].to_s == "method"
		meths.push(ReferenceController.create_method_string(mem))
      end
    end

    return meths
  end

  def self.get_sorted_methods(object)
    return get_methods(object).sort
  end

  def self.get_members(object)
    mems = []
    object["members"].each do |mem|
      if mem["type"].to_s == "variable"
        mems.push(ReferenceController.create_var_string(mem))
      end
    end

    return mems
  end

  def self.get_sorted_members(object)
    return get_members(object).sort
  end

  # Note: if two classes have the same name shit will break
  def self.get_classes_hash(objects)
    classes = {}
    objects.each do |obj|
      if obj["type"].to_s == "class"
        classes[obj["name"].to_s] = obj
      end
    end

    return classes
  end

  def self.get_sorted_classes(objects)
    classes_hash = get_classes_hash(objects)

    classes = []

    classes_hash.sort.each do |k, v|
      classes.push(v)
    end

    return classes
  end

  def self.get_global_functions(objects)
    functions = []
    objects.each do |obj|
      if obj["type"].to_s == "method"
        functions.push(create_method_string(obj))
      end
    end

    return functions
  end

  def self.get_sorted_global_functions(objects)
    return get_global_functions(objects).sort
  end

  def index
    path = Rails.root.to_s + "/public/reference/ds_reference.json"
    @parsed_json = ActiveSupport::JSON.decode(IO.read(path))
  end

end
