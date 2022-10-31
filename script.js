db.product.aggregate([
    {
        $lookup:
        {
            from: "product_description",
            localField: "_id",
            foreignField: "product_id",
            as: "description"
        }
    }
]);

db.order.aggregate([
    {
        "$addFields": {
            "date_modified": {
                "$toDate": "$date_modified"
            }
        }
    }
]);


db.order.find({ 
    date_added: { 
        $gt: new Date('2021-09-01'), 
        $lt: new Date('2021-12-30') 
    }, 
    payment_method: 'Картой', 
    total: { 
        $gt: 1000 
    } 
});


db.order.createIndex({ "payment_method": 1 }, { background: true })