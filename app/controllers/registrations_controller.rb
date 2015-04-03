class RegistrationsController < Devise::RegistrationsController

  def confirm_account
  end

  def membership
    # Try to get list of countries from the cache
    @countries = $redis.get('countries')
    if @countries.nil?
      # A cache-miss, retrieve it from db
      @countries = Country.all.to_json
      $redis.set('countries', @countries)
    else
      # A cache-hit, since redis can only store strings
      # We serialize active record to json when storing
      # and convert from json when retrieving from redis
      @countries = JSON.parse(@countries)
    end

    @cc_types = $redis.get('cc_types')
    if @cc_types.nil?
      @cc_types = CreditCardType.all.to_json
      $redis.set('cc_types', @cc_types)
    else
      @cc_types = JSON.parse(@cc_types)
    end

    @form = MembershipForm.new

  end

  protected
    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation, :terms_of_service)
    end

    def after_sign_up_path_for(resource)
      '/users/registrations/membership'
    end

    def after_inactive_sign_up_path_for(resource)
      '/users/registrations/confirm_account'
    end

    def after_sign_in_path_for(resources)
      '/shop/browse'
    end
end