# README

The code is deployed to Heroku so you can test the calculator without needing to run it locally
https://secure-bayou-25077.herokuapp.com/

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
## Answers

```
Suppose we discover a bug with our algorithm and investors for two deals had incorrect
allocations. This means that some of the investors ended up investing more than they were allowed to
while others invested less than they were allowed to. One of deals happened two years ago and the
other one happened two weeks ago. Please describe, in detail, how would you go about correcting this
issue and how would you communicate this to the affected customers.
```

I am going to make an assumption that all investors invested under their requested amount, otherwise the bug would have been more noticable two years ago. This simplifies the probablem a little bit because we do not have angry investors who will want a refund.

I think transparency with the algorithm we use can help moving forward. We should publish the formuala we are using to pro rate investments, and allow users to see how their final investment amount is being calculated for each investment. I believe this is possible without an individual investor knowing the requested amount or the average investment amount of another investor because we use aggregate totals in the calculation. For each investment an investor should be able to see the total allocation that is being raised, their average investment amount, the total request amount for the investment, and the total average investment across all investors.

I think this approach demonstrates that we made an honest mistake and helps prevent damage to our reputation.

For the deal that occurred two years ago, I think the only course of action is to reach out to the investors who received less than what they were allowed. We should let them know how much less they received, link them to the published post detailing how we will prevent this from happening moving forward, and adjust their average investment out as if they had been able to invest the full amount in the deal to help give them the option of a higher allotted amount moving forward.

If it is possible, we should fix the bug for the deal that occurred two weeks ago and adjust the allocated investment amounts for everyone involved in the deal. If the funds have already been distributed to the company, or we have written policies that prohibit this sort of correction, then we will need to approach the two week deal the same way we approach the the deal that occurred two years ago.

```
An angry investor sent us a note about how they keep getting squeezed down to $25K per deal even
though their requested amount is $100K. Underneath the hood, this was because there's limited
allocation (low supply) and a high volume of investors looking to invest (high demand). How should
we communicate this to an investor in a way that minimizes the damage to our relationship with
the investor?

In addition, can you think of a better way we could change the proration basis logic so that
this could potentially happen less often?
```

We should empathize with their frustration but also mention that we are happy that they are finding value in the deals we are offering. We should explain that in order to allow investors to participate in every deal they find value in, then sometimes we have to limit the amount an individual can invest in a deal.

Moving forward, we may be able to improve our proration basis by using average requested amount instead of average invested amount. This will allow the investor above to be allocated more in subsequent deals. Another potential solution would be to track the total amount they have been limited, but I am not sure how we would include this information in the proration basis. It seems like we should be able to though.
* ...
