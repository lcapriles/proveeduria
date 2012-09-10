module ApplicationHelper

  def ordenacion(columna, titulo = nil)
    titulo ||= columna.titelize
    clase_css = columna == columna_sort ? "current #{orden_sort}" : nil
    orden = columna == columna_sort && orden_sort == "asc" ? "desc" : "asc"
    link_to titulo, { :sort => columna, :orden => orden }, { :class => clase_css }
  end

  def render_multicolumn_list(items, cols=2)

    rendered=""

    if items.size != 0
      group_size = items.size/cols
      group_size += 1 if items.size%cols > 0

      items.in_groups_of(group_size) do |group|
        rendered << %{ <div style="float: left;"><ul style="list-style-type:none" > }
        group.each do |item|
          rendered << "<li class='data_li'>" << item << "</li>" if item
        end
        rendered << %{ </ul></div> }
      end
    end
    return rendered.html_safe

  end

end
