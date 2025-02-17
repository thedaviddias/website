module ViewComponents
  class SiteFooter < ViewComponent
    extend Mandate::Memoize

    delegate :namespace_name, :controller_name,
      to: :view_context

    def to_s
      Rails.cache.fetch(cache_key) do
        tag.footer(id: "site-footer") do
          parts = []
          parts << render(template: 'components/footer/external') unless user_signed_in?
          parts << render(template: 'components/footer/shared')
          safe_join(parts)
        end
      end
    end

    private
    def cache_key
      parts = digests
      parts << ::Track.active.count
      parts << user_part

      parts.join(':')
    end

    def user_part
      return 0 unless user_signed_in?

      current_user.captcha_required? ? 2 : 1
    end

    def digests
      %w[external shared].map do |file|
        Digest::SHA1.hexdigest(File.read(Rails.root.join('app', 'views', 'components', 'footer', "#{file}.html.haml")))
      end
    end
  end
end
