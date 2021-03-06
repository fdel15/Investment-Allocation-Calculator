Rails.application.routes.draw do
  get '/', action: 'allocation_calculator', controller: 'pages'
end
