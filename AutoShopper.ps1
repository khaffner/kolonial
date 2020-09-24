# Docs: https://github.com/kolonialno/api-docs/blob/master/README.md

Clear-Host

$UserAgent = $env:USERAGENT
$Token = $env:TOKEN
$UserName = $env:USERNAME
$Password = $env:PASSWORD
$headers = @{'X-Client-Token'=$Token}
$baseurl = "https://kolonial.no/api/v1"

$r = Invoke-RestMethod -Uri "$baseurl/user/login/" -Method Post -UserAgent $UserAgent -Headers $headers -Body @{'username'=$UserName;'password'=$Password}

# Building cookie with session id
$Cookie = New-Object System.Net.Cookie
$Cookie.Name   = 'sessionid'
$Cookie.Value  = $r.sessionid
$Cookie.Domain = "kolonial.no"
$WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$WebSession.Cookies.Add($Cookie)

# Clearing cart first
Write-Host "Clearing cart" -ForegroundColor Yellow
$c = Invoke-RestMethod -Uri "$baseurl/cart/clear/" -Method Post -WebSession $WebSession -Headers $headers -UserAgent $UserAgent

# Importing shopping list and looping through it
$ShoppingList = Import-Csv -Path .\List.csv -Delimiter ';'
Foreach($category in $ShoppingList) {

    # Getting all products from given category
    $products = (Invoke-RestMethod -Method Get -Uri "$baseurl/productcategories/$($category.CategoryID)" -Headers $headers).products
    if($category.FilterInclude) {
        # Keep only items with given string in name
        $products = $products | Where-Object full_name -Like "*$($category.FilterInclude)*" 
    }
    if($category.FilterExclude) {
        # Remove items with given string in name
        $products = $products | Where-Object full_name -NotLike "*$($category.FilterExclude)*"  
    }
    if($products.count -ge 1)
    {
        # Sort products by their gross unit price and select the cheapest
        $products = $products | sort-object { [int]$_.gross_unit_price } 
        $products = $products | Select-Object -First 1

        # Show user what gets added
        Write-Host $products.full_name -ForegroundColor Green

        # Build json body
        $id =  $products.id
        $Quantity =  $category.Quantity
        $body = "{`"items`": [{`"product_id`": $id, `"quantity`": $Quantity}]}"

        # Add to cart
        $r = Invoke-RestMethod -Uri "$baseurl/cart/items/" -Method Post -Body $body -ContentType application/json -UserAgent $UserAgent -Headers $headers -WebSession $WebSession
    }
    else {
        Write-Host "Did not find item of category `"$($category.CategoryName)`" that fits the criteria" -ForegroundColor Red
    }
}
$l = Invoke-RestMethod -Uri "$baseurl/user/logout/" -Method Post -Headers $headers
