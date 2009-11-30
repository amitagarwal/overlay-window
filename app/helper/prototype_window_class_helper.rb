# Prototype Window Class Helper (http://pwc-helper.xurdeonrails.com)
# by Jorge D�az (http://xurde.info)
# thanks to Sebastien Gruhier for his Prototype Window Class (http://prototype-window.xilinus.com/)

#Quick use:
#Reference this helper in your rails applicaction adding -> helper :prototype_window_class in your application.rb
#You must include in the template header the prototype window class javascripts and the .css theme you want to use.
#This code in your template might be enough:

  #  <%= stylesheet_link_tag 'default' %> (or theme you wanna use)
  #  <%= stylesheet_link_tag 'alert' %>
  #  <%= javascript_include_tag :defaults %>
  #  <%= javascript_include_tag 'window'%>


module PrototypeWindowClassHelper

  def params_for_javascript(params) #options_for_javascript doesn't works fine

    js_params = params.map {|k, v| "#{k}: #{
        case v
          when Hash then params_for_javascript( v )
          when String then v =~ /.*\..*/ ? "#{v}" : "'#{v}'" # hack for detecting js handlers in format Class.method
        else v   #Isn't neither Hash or String
        end }"}.sort.join(', ')

    js_params = "{#{js_params}}" unless js_params.empty?
        
    js_params
  end

  def link_to_prototype_dialog( name, content_data = {}, dialog_kind = 'alert', options = { :windowParameters => {} } , html_options = {} )

    #dialog_kind: 'alert' (default), 'confirm' or 'info' (info dialogs should be destroyed with a javascript function call 'win.destroy')
    #options for this helper depending the dialog_kind: http://prototype-window.xilinus.com/documentation.html#alert (#confirm or #info)

    options[:windowParameters][:showEffect] = 'Element.show' unless options[:windowParameters][:showEffect]
    options[:windowParameters][:hideEffect] = 'Element.hide' unless options[:windowParameters][:hideEffect]
    
    content = ''
    
    content << ("'" + content_data.delete(:text) + "'") if content_data[:text]
    
    content_data[:url] = url_for(content_data[:url]) if content_data[:url]
    content << params_for_javascript(content_data)
    
    js_code ="Dialog.#{dialog_kind}( #{content},  #{params_for_javascript(options) } ); "
    p '01'
    puts js_code.inspect
     p html_options[:onclick].inspect
    content_tag(
           "a", name,
           html_options.merge({
             :href => html_options[:href] || "#",
             :onclick => (html_options[:onclick] ? "#{html_options[:onclick]}; " : "") + js_code + '  return false;' }))
  end

  def link_to_prototype_window( name, window_id, options = { :windowParameters => {} } , html_options = {} )

    #window_id must be unique and it's destroyed on window close.
    #options for this helper: http://prototype-window.xilinus.com/documentation.html#initialize

    js_code ="var win = new Window( '#{window_id}', #{params_for_javascript(options) } );  win.show();  win.setDestroyOnClose();"
    content_tag(
           "a", name,
           html_options.merge({
             :href => html_options[:href] || "#",
             :onclick => (html_options[:onclick] ? "#{html_options[:onclick]}; " : "") + js_code }))
  end
  def link_to_prototype_confirm_url( name, window_id, options = { :windowParameters => {} } , html_options = {} )

    #window_id must be unique and it's destroyed on window close.
    #options for this helper: http://prototype-window.xilinus.com/documentation.html#initialize

    js_code ="var win = new Window( '#{window_id}', #{params_for_javascript(options) } );  win.show();  win.setDestroyOnClose();"
    content_tag(
           "a", "name",
           html_options.merge({
             :href =>    "www.google.com",
             :Onclick => (html_options[:onclick] ? "#{html_options[:onclick]}; " : "") + js_code }))
  end

end
