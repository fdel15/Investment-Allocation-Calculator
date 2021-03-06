Rails.application.routes.draw do
  get '/', action: 'allocation_calculator', controller: 'pages'
  post '/calculate', action: 'calculate', controller: 'pages'
end
