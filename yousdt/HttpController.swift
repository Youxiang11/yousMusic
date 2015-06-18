//数据
import UIKit

class HttpController:NSObject{
    var delegate:HttpProtocol?
    
    func onSearch(url: String){
        Alamofire.manager.request(Method.GET, url).responseJSON(options: NSJSONReadingOptions.MutableContainers) { (_, _, data, error) -> Void in
            self.delegate?.didRecieveResults(data!)
        }
    }
    
}


protocol HttpProtocol{
    func didRecieveResults(results: AnyObject)
}