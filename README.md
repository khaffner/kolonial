# Kolonial

## What is this?
This repo contains tools I use for automating my shopping at [Kolonial.no](https://kolonial.no)\
At the moment it only contains what I call "AutoShopper", a Powershell script that:
1. Clears the shopping cart
2. Reads the csv
3. Gets the cheapest product that fits the criteria according to csv
4. Adds the product to the shopping cart

Afterwards, you may want to look through the cart to make sure everything is ok, adjust the quantities, and of course order and pay.

## How do I use this?
- Clone this repo.
- You need an account at [Kolonial.no](https://kolonial.no).
- Their API isn't open, you must contact Kolonial to get api access. [Look here.](https://github.com/kolonialno/api-docs)
- Remove "_template" from the name of the csv and env file in this repo.
- Populate the now called secrets.env with the secrets.
- Populate the now called List.csv
  - "CategoryName" is a friendly name for the category. Call it whatever you want.
  - "CategoryID" is the ID of the category you wish to buy. For example, the CategoryID [here](https://kolonial.no/kategorier/142-oster/421-revet-ost/) is 421.
  - "FilterInclude" is a string that the product name must contain. Wildcards (*) are allowed. Optional.
  - "FilterExclude" is a string that the product name must NOT contain. Wildcards (*) are allowed. Optional.
  - "Quantity" is how many of the items you want. 1 is a good default value.
- Then run with ```docker-compose up --build```