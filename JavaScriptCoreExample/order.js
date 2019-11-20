var discount = 0.10; // 10% discount on all products

function getDiscountForProduct(product) {
    if (product.quantity > 10) {
        return discount * 2; // 20% if you order more than 10 items
    }
    return discount;
}

function getTotalPriceOfProduct(product) {
    var price = product.price * (1 - discount);
    return price * product.quantity;
}

function getPriceAndDiscountOfProduct(product) {
    var discount = getDiscountForProduct(product);
    var price = discountedPrice(product.price, discount);
    var totalDiscount = discount * product.quantity;
    var totalPrice = price * product.quantity;
    return {"price" : totalPrice, "discount" : totalDiscount}
}

function getTotalPriceAndDiscountOfOrder(order) {
    var totalPrice = 0;
    var totalDiscount = 0;
    for (var p = 0; p < order.products.length;p++) {
        var totalProduct = getPriceAndDiscountOfProduct(order.products[p])
        totalPrice += totalProduct["price"];
        totalDiscount += totalProduct["discount"]
    }
    return {"price" : totalPrice, "discount" : totalDiscount};
}

function getProduct(name, price) {
    return ProductJS.createProductWithNamePriceQuantity(name, price, 0);
}


