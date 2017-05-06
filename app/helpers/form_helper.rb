module DearFcc
  class App
    module FormHelper
      def write_dear_fcc_comment
        hidden_fields = ""
        comment_elements.each_with_index.map do |element, i|
          name = "comment[element_#{i}]"

          case element["type"]
          when "user-select"
            choices = element["choices"].map{ |opt| [opt, opt] }
            content_tag(:fieldset) do
              label_tag(name, caption: nil){ element["prefix"] } +
                select_tag(name, options: choices, class: "form-control")
            end

          when "user-select-or-other"
            other_name = "comment[element_#{i}_other]"
            choices = element["choices"].map do |opt|
              [opt, ["#{element['prefix']}".strip, opt].join(" ")]
            end<< ["Other..", "other"]

            content_tag(:fieldset, class: "select-or-other") do
              label_tag(name, caption: nil){ element["prefix"] } +
                select_tag(name, options: choices, class: "form-control") +
                content_tag(:div, class: "other"){ text_field_tag(other_name, class: "form-control") }
            end

          when "random"
            string = ["#{element['prefix']}".strip, element["choices"].sample].join(" ")
            hidden_fields << hidden_field_tag(name, value: string)
            string

          when "freeform"
            content_tag(:fieldset) do
              label_tag(name, caption: nil){ element["prompt"] } +
                text_area_tag(name, value: element["placeholder"], class: "form-control", rows: 5)
            end

          when "break"
            content_tag(:br)
          end
        end.join(" ").html_safe << hidden_fields.html_safe
      end

      def read_dear_fcc_comment(params)
        comment = ""

        comment_elements.each_with_index do |element, i|
          name = "element_#{i}"

          case element["type"]
          when "user-select-or-other"
            if params[name] == "other"
              comment << " " + params.fetch("#{name}_other").strip
            else
              comment << " " + params.fetch(name).strip
            end

          when "break"
            comment << "\n\n"

          else
            comment << " " + params.fetch(name).strip
          end
        end

        comment.strip
      end

      def estimate_textarea_rows(comment)
        (comment.size / 70.0).round
      end

      private

      def comment_elements
        YAML.load_file("#{Padrino.root}/config/comment-elements.yml")
      end
    end

    helpers FormHelper
  end
end
