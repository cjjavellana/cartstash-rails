module FormValidationHelper

  def form_error_messages!(form)
    return '' if form.errors.empty?

    messages = form.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    html = <<-HTML
    <div id="error_explanation" class="alert alert-danger">
      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

  def form_error_messages?
    form.errors.empty? ? false : true
  end
end