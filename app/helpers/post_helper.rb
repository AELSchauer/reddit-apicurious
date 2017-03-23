module PostHelper
  # def nested_comments_tag(comment)
  #     html = content_tag(:ul) {
  #       ul_contents = ""

  #       if comment.body.empty?
  #         ul_contents << link_to(content_tag(:li, "View Thread"), "#").html_safe
  #       else
  #         ul_contents << content_tag(:li, comment.body)
  #         comment.replies.each do |reply|
  #           ul_contents << nested_comments_tag(reply)
  #         end
  #       end

  #       ul_contents.html_safe
  #     }.html_safe
  # end

  def nested_comments_tag(comment)
    unless comment.empty?
      html = content_tag(:ul) {
        ul_contents = ""

        if comment.body.empty?
          ul_contents << link_to(content_tag(:li, "View Thread"), "#")
        else
          ul_contents << content_tag(:li, comment.body)
          comment.replies.each do |reply|
            ul_contents << nested_comments_tag(reply)
          end
        end

        ul_contents.html_safe
      }.html_safe
    end
  end
end

