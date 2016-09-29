//
//  ViewController.swift
//  BuscaLibro
//
//  Created by Francisco Ulises Roldan Trejo on 25/09/16.
//  Copyright © 2016 Francisco Ulises Roldan Trejo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtResConsulta: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        var vTexto = ""
        self.view.endEditing(true)
        vTexto = textField.text!
        txtResConsulta.text = (fnTraeDatLibro(vTexto))
        return true
        
    }
    
    func fnTraeDatLibro(pTexto : String) -> String {
        var vResultado : NSString = ""
        var vRetorno : String = ""
        let vText = pTexto
        let urls =  "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + vText
        let url = NSURL(string: urls)
        
        if Reachability.isConnectedToNetwork() == true {
            let datos:NSData? = NSData(contentsOfURL: url!)
            let texto2 = NSString(data:datos!, encoding:NSUTF8StringEncoding)
            vRetorno = texto2 as! String
        } else {
            fnMuestraAlerta()
            vRetorno = "Vuelva a intentarlo por favor!"
        }
        
        /*let sesion = NSURLSession.sharedSession()
        let bloque = { (datos: NSData?, resp : NSURLResponse?, error : NSError?) -> Void in let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
            
            vResultado = texto!
            //self.txtResConsulta.text = texto
        }
        let dt = sesion.dataTaskWithURL(url!, completionHandler: bloque)
            dt.resume()
        */
        
        /*
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!){(data, response, error) in // encodes the raw data into UTF8 string data. println(NSString(data: data, encoding:NSUTF8StringEncoding))
        }
        // “Resume” the NSURL session. Data comes from remote site.
        task.resume()
        self.txtResConsulta.text = String(task.response)
        */
        
        //vRetorno = vResultado as String
        if vRetorno == "{}"{
           vRetorno = "No se encontró el registro con este ISBN. Vuleva a intentarlo!"
        }
        return (vRetorno)
    }
    
    
    
    func fnMuestraAlerta() -> Void {
        var alertaDos = UIAlertController(title: "Verificación de red", message: "En este momento no se encuentra disponible el acceso a Internet, por favor inténtalo más tarde.", preferredStyle: UIAlertControllerStyle.Alert)
        
        //Ahora es mucho mas sencillo, y podemos añadir nuevos botones y usar handler para capturar el botón seleccionado y hacer algo.
        
        alertaDos.addAction(UIAlertAction(title: "Salir" , style: UIAlertActionStyle.Cancel ,handler: {alerAction in
            print("Pulsado el boton de Salir")}))
        
        //Para hacer que la alerta se muestre usamos presentViewController, a diferencia de Objective C que como recordaremos se usa [Show Alerta]
        
        self.presentViewController(alertaDos, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    

}

