class Api::ScriptTagsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_bc_store

  def store_script_details
    render json: { store: @store, scripts: @store.scripts }
  end

  def update_script_data
    script = Script.find(params[:script_id])
    if script.name == 'Main Script'
      if params[:status] == 'true' || params[:status] == true
        res = script.install_main_script(@store)
        if res.code == 200
          script.update(uuid: res['data']['uuid'], api_client_id: res['data']['api_client_id'], status: true)
        else
          raise 'error'
        end
      else
        script.uninstall_main_script(@store)
        script.update(status: false)
      end
    elsif script.name == 'Conversion Pixel'
      if params[:status] == 'true' || params[:status] == true
        res = script.install_pixel_script(@store)
        if res.code == 200
          script.update(uuid: res['data']['uuid'], api_client_id: res['data']['api_client_id'], status: true)
        else
          raise 'error'
        end
      else
        script.uninstall_pixel_script(@store)
        script.update(status: false)
      end
    elsif script.name == 'Add to Cart'
      if params[:status] == 'true' || params[:status] == true
        res = script.install_add_to_cart_script(@store)
        if res.code == 200
          script.update(uuid: res['data']['uuid'], api_client_id: res['data']['api_client_id'], status: true)
        else
          raise 'error'
        end
      else
        script.uninstall_add_to_cart_script(@store)
        script.update(status: false)
      end
    end
    render json: { status: true }
  end

  def update_store_property
    if !@store.enabled_scripts
      @store.update(property_id: params[:new_value], enabled_scripts: true)
      install_all_scripts
    else
      @store.update(property_id: params[:new_value])
    end
    render json: { status: true, store: @store}
  end

  private

  def set_bc_store
    @store = Store.find(params[:store_id])
    Bigcommerce.configure do |config|
      config.store_hash = @store.store_hash
      config.client_id = ENV['BC_CLIENT_ID']
      config.access_token = @store.access_token
    end
  end

  def update_script(script)
    if script.name == 'Main Script'
      store_variants = HTTParty.post(
        "https://api.bigcommerce.com/stores/#{@store.store_hash}/v3/content/scripts",
        headers: {
          "X-Auth-Token": @store.access_token,
          'Content-Type' => 'application/json'
        },
        body: {
          "name": 'Main  Pinterest Script',
          "description": 'Main  Pinterest Script',
          "html": script.main_script(@store.property_id),
          "auto_uninstall": true,
          "load_method": 'default',
          "location": 'head',
          "visibility": 'all_pages',
          "kind": 'script_tag',
          "consent_category": 'essential'
        }.to_json
      )
    else
    end
  end

  def install_all_scripts
    main_script = @store.scripts.find_by(name: 'Main Script')
    conversion_pixel = @store.scripts.find_by(name: 'Conversion Pixel')
    add_to_cart = @store.scripts.find_by(name: 'Add to Cart')
    
    res = main_script.install_main_script(@store)
    main_script.update(uuid: res['data']['uuid'], api_client_id: res['data']['api_client_id'], status: true)

    res = conversion_pixel.install_pixel_script(@store)
    conversion_pixel.update(uuid: res['data']['uuid'], api_client_id: res['data']['api_client_id'], status: true)

    res = add_to_cart.install_add_to_cart_script(@store)
    add_to_cart.update(uuid: res['data']['uuid'], api_client_id: res['data']['api_client_id'], status: true)
  end
end
