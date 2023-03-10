package com.flowershop.product.controller;

import java.io.File;
import java.io.IOException;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.flowershop.cart.service.CartService;
import com.flowershop.login.domain.UserVo;
import com.flowershop.product.domain.ProductVo;
import com.flowershop.product.domain.SaleVo;
import com.flowershop.product.service.ProductService;

@Controller
public class ProductController {

	private Log log = LogFactory.getLog(ProductController.class);

	@Autowired
	private ProductService productService;
	
	@Autowired
	private CartService cartService;
	
	@RequestMapping(value="/productList", method={RequestMethod.GET, RequestMethod.POST})
	public String ProductList(@ModelAttribute("ProductVo") ProductVo productVo, Model model, HttpSession session){
		
		Map<String, Object> map = productService.productList(productVo); 
		 String path = "C:\\flowershopImage\\upload\\";
/*		String path = "C:\\project\\ganadamart\\"
                + ".metadata\\.plugins\\org.eclipse.wst.server.core\\"
                + "tmp0\\wtpwebapps\\flowerShop\\images\\";*/
		
		UserVo userVo = (UserVo)session.getAttribute("authUser");
		model.addAttribute("userVo", userVo);
		model.addAttribute("path", path);
		
		model.addAttribute("pageVO", productVo);
		
		model.addAttribute("list", map.get("list")); 
		/*model.addAttribute("path", path); */
		return "product/productList";
	}
	
	@RequestMapping(value="/productWrite", method={RequestMethod.GET, RequestMethod.POST})
	public String ProductWrite(Model model){
		
		return "product/productWrite";
	}
	
	@RequestMapping(value="/productWriteSave", method={RequestMethod.GET, RequestMethod.POST})
	public String ProductWriteSave(@ModelAttribute ProductVo productVo, @RequestParam("product_photo")MultipartFile multipartFile){
		
		System.out.println(productVo);
		System.out.println(multipartFile);
		
		String filename = "";
        // ????????????(????????????)??? ?????????
        if(!productVo.getProduct_photo().isEmpty()){
            filename = productVo.getProduct_photo().getOriginalFilename();
            // ?????????????????? - ?????? ????????? ??????
            //String path = "C:\\Users\\doubles\\Desktop\\workspace\\gitSpring\\"
            //                + "spring02\\src\\main\\webapp\\WEB-INF\\views\\images";
            // ?????????????????? - ?????? ????????? ??????
            String path = "C:\\flowershopImage\\upload\\";

            try {
                new File(path).mkdirs(); // ???????????? ??????
                // ??????????????????(??????)??? ????????? ????????? ????????? ??????????????? ??????
                productVo.getProduct_photo().transferTo(new File(path+filename));
            } catch (Exception e) {
                e.printStackTrace();
            }
            productVo.setProduct_url(filename); // ?????? ????????? Vo??? ??????
            productService.insertProduct(productVo); // ????????? ??????
        }
        return "redirect:/productList";
	}
	
	@RequestMapping(value="/productDetail", method=RequestMethod.POST)
	public String ProductDetail(@ModelAttribute("ProductVo") ProductVo productVo, Model model, HttpSession session){
		
		ProductVo list = productService.productDetail(productVo);
		int resultCnt = productService.LikeSelect(productVo); 
		if(list.getProduct_saleyn().equals("Y")){
			SaleVo saleVo = productService.selectSaleInfo(productVo);
			System.out.println(saleVo);
			model.addAttribute("SaleVo", saleVo); 
		}
		model.addAttribute("like", resultCnt); 
		model.addAttribute("ProductVo", list); 
		model.addAttribute("pageVo", productVo);
		return "/product/productDetail";
	}
	
	@RequestMapping(value="/productUpdate", method=RequestMethod.POST)
	public String ProductUpdate(@ModelAttribute("ProductVo") ProductVo productVo, Model model, HttpSession session){
		ProductVo list = productService.productDetail(productVo);
		model.addAttribute("ProductVo", list); 
		return "/product/productUpdate";
	}
	
	@RequestMapping(value="/productUpdateSave", method=RequestMethod.POST)
	public String ProductUpdateSave(@ModelAttribute("ProductVo") ProductVo productVo, Model model, HttpSession session){
		String filename = "";
        // ????????????(????????????)??? ????????????
        if(!productVo.getProduct_photo().isEmpty()){
            filename = productVo.getProduct_photo().getOriginalFilename();
            
            String path = "C:\\project\\flowerShopProject\\"
                    + ".metadata\\.plugins\\org.eclipse.wst.server.core\\"
                    + "tmp0\\wtpwebapps\\flowerShop\\resources\\img\\";
            try {
                new File(path).mkdirs(); // ???????????? ??????
                // ??????????????????(??????)??? ????????? ????????? ????????? ??????????????? ??????
                productVo.getProduct_photo().transferTo(new File(path+filename));
            } catch (Exception e) { //????????????
                e.printStackTrace();
            }
            productVo.setProduct_url(filename);
        // ??????????????? ???????????? ?????????
        } else {
            // ????????? ?????????
            ProductVo vo2 = productService.productDetail(productVo); 
            productVo.setProduct_url(vo2.getProduct_url()); 
        }
        productService.productUpdateSave(productVo);
        return "redirect:/productList";
	}
	
	
	@RequestMapping(value="/productDelete", method=RequestMethod.POST)
	public String ProductDelete(@RequestParam int product_no){
		 // ?????? ????????? ??????
        String filename = productService.fileInfo(product_no);
        
        String path = "C:\\project\\flowerShopProject\\"
                + ".metadata\\.plugins\\org.eclipse.wst.server.core\\"
                + "tmp0\\wtpwebapps\\flowerShop\\resources\\img\\";
        // ?????? ????????? ??????
        if(filename != null){
            File file = new File(path+filename);
            // ????????? ????????????
            if (file.exists()){ 
                file.delete(); // ?????? ??????
            }
        }
        productService.productDelete(product_no); 
        
        return "redirect:productList";
    }
	
	
	@RequestMapping(value="/viewLowPrice", method={RequestMethod.GET, RequestMethod.POST})
	public String ViewLowPrice(@ModelAttribute ProductVo productVo, Model model){

		Map<String, Object> map = productService.viewLowPrice(productVo); 
		
		/** ????????? ?????? */
		model.addAttribute("pageVO", productVo);
		
		model.addAttribute("list", map.get("list")); 
		return "product/productList";
	}
	
	@RequestMapping(value="/viewHighPrice", method={RequestMethod.GET, RequestMethod.POST})
	public String ViewHighPrice(@ModelAttribute ProductVo productVo, Model model){
		
		Map<String, Object> map = productService.viewHighPrice(productVo); 
		
		/** ????????? ?????? */
		model.addAttribute("pageVO", productVo);
		
		model.addAttribute("list", map.get("list")); 
		return "product/productList";
	}
	
	@RequestMapping(value="/viewName", method={RequestMethod.GET, RequestMethod.POST})
	public String ViewName(@ModelAttribute ProductVo productVo, Model model){
		
		Map<String, Object> map = productService.viewName(productVo); 
		
		/** ????????? ?????? */
		model.addAttribute("pageVO", productVo);
		
		model.addAttribute("list", map.get("list"));
		return "product/productList";
	}
	
	@RequestMapping(value="/likeUpSave", method=RequestMethod.POST)
	@ResponseBody
	public String LikeUpSave(@ModelAttribute ProductVo productVo, HttpSession session) throws IOException{
		
		if (session.getAttribute("authUser") == null){
    		return "null";
    	}
		
		UserVo userVo = (UserVo)session.getAttribute("authUser");
		String user_id = userVo.getUser_id();
		
		productVo.setUser_id(user_id);
		
		ProductVo productLike= productService.LikeUpSelect(productVo);
		
		if(productLike == null){
			productService.likeUpSave(productVo); 
			return "ok";
		}
		else return "fal";
	}
	
	/** ???????????? ?????? */
	@RequestMapping(value="/saleWrite", method=RequestMethod.POST)
	public String SaleWrite(@ModelAttribute("ProductVo") ProductVo productVo, Model model, HttpSession session){
		
		ProductVo list = productService.productDetail(productVo);
		model.addAttribute("ProductVo", list); 
		
		return "/product/sale/saleWrite";
	}
	
	@RequestMapping(value="/saleWriteSave", method=RequestMethod.POST)
	public String SaleWriteSave(@ModelAttribute("SaleVo") SaleVo saleVo, Model model, HttpSession session){
		
		double percent = (double) (saleVo.getSale_percent() * 0.01);
		
		int minusPrice = (int) (saleVo.getProduct_price() * percent);
		
		int totalSalePrice = saleVo.getProduct_price() - minusPrice;
		saleVo.setSale_price(totalSalePrice);
		
		productService.updateSaleYn(saleVo);
		productService.saleWriteSave(saleVo);
		
		return "redirect:/productList";
	}
	
	@RequestMapping(value="/productSaleList", method={RequestMethod.GET, RequestMethod.POST})
	public String ProductSaleList(@ModelAttribute("ProductVo") ProductVo productVo, Model model, HttpSession session){
		
		Map<String, Object> map = productService.productSaleList(productVo); 
		model.addAttribute("list", map.get("list")); 
		
		UserVo userVo = (UserVo)session.getAttribute("authUser");
		model.addAttribute("userVo", userVo);
		
		return "/product/sale/productSaleList";
	}
	
	@RequestMapping(value="/saleDelete", method=RequestMethod.POST)
	public String SaleDelete(@RequestParam int product_no){
		 
		productService.productSaleDelete(product_no); 
        productService.saleDelete(product_no); 
        
        return "redirect:productSaleList";
    }
}
