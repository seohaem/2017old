<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/header.jsp"%>
<jsp:include page="${pageContext.request.contextPath }/top" />
</style>
<link href='/resources/css/buy.css' rel='stylesheet' type='text/css'>
<script type="text/javascript"
   src="${pageContext.request.contextPath }/resources/js/jquery-2.1.1.js"></script>
<script type="text/javascript"
   src="${pageContext.request.contextPath }/resources/js/jquery.validate.js"></script>
<script type="text/javascript">

$.ajax({
	type : 'POST',
	url : '${pageContext.request.contextPath }/getpoint',
	success : function(response){
		$("#my_point").text(response.data);
		$("#hiddenMyPoint").val(response.data);
	}
})

$.ajax({
	type : 'POST',
	url : '${pageContext.request.contextPath }/getlimitpoint',
	success : function(response){
		$("#limit_point").text(response.data);
		$("#hiddenLimitPoint").val(response.data);
	}
})


function buyDeliveryCheck(obj){
   if(obj.checked){
   $.ajax({
      type : 'POST',
      url : '${pageContext.request.contextPath }/buyDeliveryCheck',
       contentType: "application/x-www-form-urlencoded; charset=UTF-8",
       success : function(response){
            console.log(JSON.stringify(response.data));
            document.form.buy_name.value = response.data.user_name;
            document.form.buy_phone.value = response.data.user_phone;
            document.form.buy_addr1.value = response.data.user_addr1;
            document.form.buy_addr2.value = response.data.user_addr2;
            document.form.buy_addr3.value = response.data.user_addr3;
            document.form.buy_addr4.value = response.data.user_addr4;
       }
   });
   } else{
        document.form.buy_name.value = "";
         document.form.buy_phone.value = "";
         document.form.buy_addr1.value = "";
         document.form.buy_addr2.value = "";
         document.form.buy_addr3.value = "";
         document.form.buy_addr4.value = "";
   }
}

function returnCart() {
   if (confirm("??????????????? ????????????????????????? \n \"??????\" ??? ???????????? \n\"????????????\" ??? ?????? ?????????.") == true) {
         document.location.href="/cartList";         
      } 
}

function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail,
      roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn,
      detBdNmList, bdNm, bdKdcd, siNm, sggNm, emdNm, liNm, rn, udrtYn,
      buldMnnm, buldSlno, mtYn, lnbrMnnm, lnbrSlno, emdNo) {
   document.form.buy_addr2.value = roadAddrPart1;
   document.form.buy_addr3.value = roadAddrPart2;
   document.form.buy_addr4.value = addrDetail;
   document.form.buy_addr1.value = zipNo;
} 

function goPopup() {
   var pop = window.open(
         "${pageContext.request.contextPath }/join/postPup", "pop",
         "width=570,height=420, scrollbars=yes, resizable=yes");
}

function checkPayment() {
   var name = document.form.buy_name.value;
   var phone = document.form.buy_phone.value;
   var addr4 = document.form.buy_addr4.value;
   var usePoint1 = document.form.point.value;
   var myPoint1 = document.form.hiddenMyPoint.value;
   var limitPoint1 = document.form.hiddenLimitPoint.value;
   var nameValid = /^[???-???]{2,4}$/;
   var phoneValid = /^01([0|1|6|7|8|9]?)-([0-9]{3,4})-([0-9]{4})$/;
   var addr4Valid = /^[???-???|???-???|0-9|\*]+$/;   
   
   var usePoint = parseInt(usePoint1);
   var myPoint = parseInt(myPoint1);
   var limitPoint = parseInt(limitPoint1);
   
   if(nameValid.test(name) == false){
      alert("????????? ????????? ??????????????????.");
   } else if(phoneValid.test(phone) == false){
      alert("????????? ???????????? ??????????????????.");
   } else if(addr4Valid.test(addr4) == false){
      alert("????????? ????????? ??????????????????.");
   } else if(usePoint < 0){
	  alert("???????????? ???????????? ??????????????????.");  
   } else if(myPoint < usePoint){
	  alert("???????????? ???????????????.");
   } else if(limitPoint < usePoint){
	   alert("??? ??????????????? ?????? ?????? ???????????? ??????????????????.");
   } else{
   
      var totalCartNo = "";  
      var cart_no = null;
      
      $(":text[name=cart_no]").each(function(i){
          cart_no = $(this).val(); 
          totalCartNo += cart_no+","; 
       });
      if (confirm("?????? ???????????????????") == true) {
         document.form.totalCartNo.value = totalCartNo;
         document.form.method="POST";         
         document.form.action="<c:url value='/payment' />";         
         document.form.submit();
      }
      return;   
   }
}
</script>

<div class="product-big-title-area">
   <div class="container">
      <div class="row">
         <div class="col-md-12">
            <div class="product-bit-title text-center">
               <h2>Buy product</h2>
            </div>
         </div>
      </div>
   </div>
</div>
<div class="single-product-area">
   <div class="row m-n">
      <div class="col-md-4 col-md-offset-4 m-t-lg">
         <!-- ************************ -->
         <form name="form1" method="post" action="#">
            <input type="hidden" name="user_id" value="${map.user_id }">
            <input type="hidden" name="allSum" value="${map.allSum}">
            <h2 class="sidebar-title">Cart List</h2>
            <table cellspacing="0" class="shop_table cart">
               <thead>
                  <tr>
                     <th class="product-subtotal">??????</th>
                     <th class="product-remove">?????????</th>
                     <th class="product-thumbnail">??????</th>
                     <th class="product-price">??????</th>
                     <th class="product-quantity">?????? ??????</th>
                  </tr>
               </thead>
               <tbody>
                  <c:forEach var="row" items="${map.list}" varStatus="i">
                     <tr class="cart_item">
                        <td class="product-remove">
                           <input type="text" size="4" style="border: 0;" name="cart_no" value="${row.cart_no}" readonly="readonly"/> 
                        </td>
                        <td class="product-thumbnail">
                           ${row.product_name }
                        </td>
                        <td class="product-name">
                           <img src="${pageContext.request.contextPath }/img/${row.product_url}" width="145" height="145">
                        </td>
                        <td class="product-quantity">
                           <div class="quantity buttons_added">
                              <input type="number" name="product_amount" size="1" class="input-text qty text" style="border: 0; text-align: center;" title="Qty" value="${row.product_amount}" readonly="readonly"> 
                              <input type="hidden" name="product_no" value="${row.product_no}">
                           </div>
                        </td>
                        <td class="product-subtotal">
                           <c:if test="${row.product_saleyn == 'N'}">
                           	<input type="number" name="product_price" size="5" style="border: 0;text-align: center;" value="${row.product_price }" readonly="readonly"/> 
                       	   </c:if>
                       	   <c:if test="${row.product_saleyn == 'Y'}">
                            <input type="number" name="product_price" size="5" style="border: 0;text-align: center;" value="${row.sale_price }" readonly="readonly"/>
                           </c:if> 
                        </td>            
                     </tr>
                  </c:forEach>
               </tbody>
            </table>
            <h2 class="sidebar-title">Total Price</h2>
            <span class="subCreateHeader">5?????? ????????? ????????? ????????? 2500????????????.</span>
            <table cellspacing="0" class="shop_table cart">
               <tbody>
                  <tr class="cart-subtotal">
                     <th>?????? ??????</th>
                     <td><span class="amount">${map.sumMoney }</span></td>
                  </tr>
                  <c:if test="${map.sumMoney == 0}">
                     <tr class="shipping">
                        <th>?????????</th>
                        <td>0</td>
                     </tr>

                     <tr class="order-total">
                        <th>??? ????????????</th>
                        <td>
                           <strong><span class="amount">0</span></strong>
                        </td>
                     </tr>
                  </c:if>

                  <c:if test="${map.sumMoney != 0}">
                     <tr class="shipping">
                        <th>?????????</th>
                        <td>${map.fee }</td>
                     </tr>

                     <tr class="order-total">
                        <th>??? ????????????</th>
                        <td><strong><span class="amount">${map.allSum }</span></strong>
                        </td>
                     </tr>
                  </c:if>
               </tbody>
            </table>
         </form>
         <hr />
         <h2 class="sidebar-title">???????????? ??????</h2>
         <form name="form" id="form" action="#" method="post">
            <input type="hidden" name="totalCartNo" value="1">
            <input type="hidden" name="user_id" value="${map.user_id}">
            <input type="hidden" name="buy_totalPrice" value="${map.allSum}">
            <input type="hidden" name="deliveryPrice" value="${map.fee }">
            <label for="buy_delivery">????????? ????????? ???????????????.</label>
            <input type="checkbox" name="buy_delivery" id="buy_delivery" onclick="buyDeliveryCheck(this)" />
            <label for="user_id"></label> <input type="text" name="buy_name"id="buy_name" style="width: 100%" placeholder="???????????? ??????" /> <spanid="duplicateResult"></span><br /> <label for="user_name"></label>
            <input type="text" name="buy_phone" id="buy_phone"style="width: 100%" placeholder="???????????? ?????????( - ???????????? ??????)" /><br /> 
            <br />
            <input type="hidden" id="confmKey" name="confmKey" value="" />
            <input type="text" id="buy_addr1" name="buy_addr1"placeholder="????????????" readonly style="width: 100px; background-color: #e2e2e2;" />&nbsp; 
            <input type="button" class="btn btn-default btn-sm" value="????????????" onclick="goPopup()"><br /> 
            <input type="text"id="buy_addr2" placeholder="?????????" name="buy_addr2" readonly style="width: 100%; background-color: #e2e2e2;" /><br /> 
            <input type="text" id="buy_addr3" placeholder="(???,???,???)" readonly="readonly" name="buy_addr3" style="width: 50%; background-color: #e2e2e2;" value="" /> 
            <input type="text" id="buy_addr4" name="buy_addr4" placeholder="(????????????)" value="" /><br />
            <hr />
            <h2 class="sidebar-title">Point ??????/??????</h2>
            <label for="point">?????? ??? ????????? :&nbsp;</label>
            <input type="text" id="point" name="point" value="0" style="height:15px;"/><br></br>     
            	<p id="my_point_text" style="float:left; padding-right:5px">?????? ????????? :</p>
            	<p id="my_point"></p>
            <input type="hidden" id="hiddenMyPoint" value=""/><br></br>	
            	<p id="my_point_text" style="float:left; padding-right:5px">?????? ?????? ?????????(??? ??????????????? 10% ??????) :</p>
            	<p id="limit_point"/></p><br></br>
            <input type="hidden" id="hiddenLimitPoint" value=""/><br></br>	
            <hr />
            <input type="button" class="btn btn-lg btn-primary btn-block"value="?????? ??????" onclick="checkPayment()" /> 
            <input type="button"class="btn btn-lg btn-warning btn-block" value="??????????????? ????????????"onclick="returnCart()" />
         </form>
      </div>
   </div>
</div>

<%@ include file="/WEB-INF/include/footer.jsp"%>