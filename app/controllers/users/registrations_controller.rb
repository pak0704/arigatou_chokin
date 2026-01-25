class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    # メールアドレス変更フォームの場合
    if params[:user][:form_type] == "email"
      if params[:user][:current_password].blank?
        resource.errors.add(:current_password, :blank)
        set_minimum_password_length
        respond_with resource
        return
      end
    end

    # パスワード変更フォームの場合
    if params[:user][:form_type] == "password"
      if params[:user][:password].blank?
        resource.errors.add(:password, :blank)
        set_minimum_password_length
        respond_with resource
        return
      end
      if params[:user][:password_confirmation].blank?
        resource.errors.add(:password_confirmation, :blank)
        set_minimum_password_length
        respond_with resource
        return
      end
    end

    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?

    if resource_updated
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def update_resource(resource, params)
    if params[:password].present?
      resource.update_with_password(params.except(:form_type))
    else
      resource.update_without_password(params.except(:current_password, :form_type))
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [ :form_type ])
  end
end
