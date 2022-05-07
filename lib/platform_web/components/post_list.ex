defmodule PlatformWeb.Components.PostList do
  use Surface.LiveComponent

  slot(author_url, required: true)
  slot(author_name, required: true)

  slot(post_name, required: true)

  slot(comment_count, required: true)

  def render(assigns) do
    ~F"""
    <div>
      <#slot name="author_name" />

      <#slot name="post_name" />
      <#slot name="comment_count" />
    </div>
    """
  end
end
