# README

The code is deployed to Heroku so you can test the calculator without needing to run it locally
https://secure-bayou-25077.herokuapp.com/

- [Running App Locally](#run-app-locally)
- [BackEnd](#backend)
- [FrontEnd](#frontend)

## Run app locally

If you need to run the app locally, you should be able to run it with the following commands after pulling down the repository.

```
bundle install
rails yarn:install 

# Run each command in a separate terminal window
bundle exec rails s
bin/webpack-dev-server
```

By default the app is running on `localhost:3000`

I also created a rake task that runs all of the provided examples. You can run this rake task with the following command:

`bundle exec rake investment_allocator:examples`

If you have additional data sets you can run them with this task to check the accuracy of the algorithm.

**NOTE: I changed the keys in the example data for it to work. I renamed `name` to `id`, and camelcased all keys.**

## Backend
I created a Rails application for the website because I am most comfortable writing the algorithm code in Ruby.

I created a service class `InvestmentAllocator` to perform the pro rate calculation. This service has a class method that will instantiate a new instance with input data and perform the calculation. I like using the class method instead of directly instantiating the object in the controller because it allows us to hide more of the implementation details from the controller. The controller just passes in filtered params, and the class method is responsible for knowing how to instantiate itself.

I made an assumption that the number of investors in any particular deal will never be a large number and that looping through all investors multiple times is acceptable.

The algorithm has an early exit if the total amount we have to allocate is less than the investors requested amount. In this situation, every investor can be given their requested amount.

When this is not the case, then we need to use the pro rate algorithm. The algorithm is defined as a method in the class, and given the examples in this project, I implemented the formula as

`allocation_amount * (average_amount / investor_average_sum)`

where `average_amount` is an individual investor's average investment amount, and `investor_average_sum` is the total of all average_amounts of the investors participating in a deal.

The formula will iterate through the investors multiple times until all of the money has been allocated. An investor will continue to have their investment amount increased on each loop as long as the total they have invested is less than the amount they have requested to invest.

After each loop, we decrease the amount of money that needs to be allocated by the amount that was allocated in that loop. This allows our formula to fairly allocate the remaining money to all investors who have requested more than their current allocation.

The algorithm class can be found `app/services/investment_allocator.rb`

## Frontend

I integrated Svelte for the front end. My reasons for doing this are:

1. I wanted to use Javascript instead of Ruby because it will provide a better experience without needing to refresh the page while inputting the data.

2. I wanted to use a modern FE library instead of jQuery because writing javascript code in components makes the code easier to reason about and understand.

3. React and Vue felt like overkill, and I am more familiar with Svelte since I have been learning it recently.

Svelte provides the dynamic experience I was going for. You can easily add, remove, and update investors as well as update the total allocation amount.

The "Calculate" button makes a POST request to our Rails controller. It updates the amount each investor is allocated in the "Allocated Amount" columns. Investors that are missing Name, Average Amount, or Requested Amount are not included in the data that gets sent to the backend for the calculation.

I didn't spend too much time writng CSS and styling the document, but there are many improvements we can make here if we needed to ship this as a feature.

Given enough time, I would also rewrite the algorithm in Javascript and remove the POST request. In this implementaiton, there is not really any value in using the API other than I knew I could write the algorithm faster in Ruby.

You can see the component code in `app/javascript/components`
