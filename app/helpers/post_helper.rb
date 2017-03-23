module PostHelper
  def nested_comments_tag(comment)
      html = content_tag(:ul) {
        ul_contents = ""

        if comment.body.nil?
          ul_contents << link_to(content_tag(:li, "View Thread"), "#").html_safe
        else
          ul_contents << content_tag(:li, comment.body)
        end

        comment.replies.each do |reply|
          unless reply.replies == []
            ul_contents << nested_comments_tag(reply)
          end
        end

        ul_contents.html_safe
      }.html_safe
  end
end
