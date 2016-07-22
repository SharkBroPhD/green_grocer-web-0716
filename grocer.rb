require "pry"

def consolidate_cart(cart)
  # GENERATES COUNT # 
  cart_count=Hash.new(0)
  cart.each do |item|
    cart_count[item] += 1
  end

  # CREATES NEW ARRAY WITH ITEMS AND COUNT #
  new_cart=cart.uniq
  cart_count.each do |count_item,count|
    new_cart.each do |new_cart_item|
      if new_cart_item==count_item
        new_cart_item.each do |item_name, attributes|
          new_cart[new_cart.index(new_cart_item)][item_name][:count]=count
        end
      end
    end
  end

  # CREATES NEW, FORMATTED HASH #
  merged_cart=new_cart.inject(&:merge)
end

def apply_coupons(cart, coupons)
  new_cart={}
  if coupons==[]
    return cart
  else
    coupons.each do |coupon|
      cart.each do |cart_item, attributes|
        if coupon[:item]==cart_item
          if (cart[cart_item][:count]%coupon[:num])==0
            new_cart[cart_item+" W/COUPON"]={:price=>coupon[:cost], :count=>(cart[cart_item][:count]/coupon[:num]), :clearance=>attributes[:clearance]}
            new_cart[cart_item]={:price=>attributes[:price],:count=>0, :clearance=>attributes[:clearance]}
          else 
            new_cart[cart_item+" W/COUPON"]={:price=>coupon[:cost], :count=>(cart[cart_item][:count]/coupon[:num]), :clearance=>attributes[:clearance]}
            new_cart[cart_item]={:price=>attributes[:price],:count=>(cart[cart_item][:count]%coupon[:num]), :clearance=>attributes[:clearance]}
          end
        else 
          if new_cart[cart_item]==nil
          new_cart[cart_item]=attributes
          end
        end
      end
    end
    return new_cart
  end
end


def apply_clearance(cart)
  new_cart={}
  cart.each do |cart_item, attributes|
    if attributes[:clearance]==true
      new_cart[cart_item]={:price=>(attributes[:price]*0.8).round(2), :count=>attributes[:count],:clearance=>attributes[:clearance]}
    else
      new_cart[cart_item]={:price=>attributes[:price], :count=>attributes[:count],:clearance=>attributes[:clearance]}
    end
  end
  return new_cart
end

def checkout(cart, coupons)
  total=[]
  consolodated_cart=consolidate_cart(cart)
  couponed_cart=apply_coupons(consolodated_cart,coupons)
  clearance_cart=apply_clearance(couponed_cart)
  clearance_cart.each do |item, attribute|
    total<<clearance_cart[item][:price]*clearance_cart[item][:count]
  end
  sum_total=total.inject(:+)
  if sum_total>100
    sum_total=(sum_total*0.9).round(2)
  end
  return sum_total
end
