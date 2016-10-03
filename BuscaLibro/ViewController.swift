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
    
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblAutores: UILabel!
    @IBOutlet weak var pvPortada: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        var vTexto = ""
        self.view.endEditing(true)
        vTexto = textField.text!
        let resConsulta:Array = (fnTraeDatLibro(vTexto))
        lblTitulo.text = resConsulta[0]
        lblAutores.text = resConsulta[1]
        if resConsulta[2] != "" {
            if let url = NSURL(string: resConsulta[2]) {
                if let data = NSData(contentsOfURL: url) {
                    pvPortada.image = UIImage(data: data)
                }
            }
        }else{
           //No se cuenta con la portada de este libro
        }
        
        
        //txtResConsulta.text = (fnTraeDatLibro(vTexto))
        return true
        
    }
    
    func fnTraeDatLibro(pTexto : String) -> [String] {
        var vRetorno : String = ""
        var vautores : String! = ""
        var urlPorts : String = ""
        var texto2: String = ""
        let vText = pTexto
        let urls =  "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + vText
        let url = NSURL(string: urls)
        
        if Reachability.isConnectedToNetwork() == true {
            let datos:NSData? = NSData(contentsOfURL: url!)
            //let texto2 = NSString(data:datos!, encoding:NSUTF8StringEncoding)
            //
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                let dico1 = json as! NSDictionary
                let dico2 = dico1["ISBN:"+vText]
                
                if let dicoAutores = dico2!["authors"] as? [AnyObject] {
                    for autores in dicoAutores {
                        if (vautores != "") {
                                       vautores=vautores+","+String(autores["name"]!!)
                                     }
                                   else{
                                       vautores = String(autores["name"]!!)
                                     }
                    }
                }
                do{
                    let dicoPortadas = try dico2!["cover"] as! NSDictionary
                    urlPorts = String(dicoPortadas["medium"]!)
                    //urlPorts = String(dicoPort!)
                }
                catch{
                    urlPorts=""
                }
                texto2 = dico2!["title"] as! NSString as String
                
            }
            catch _ {
            }
            
            vRetorno = texto2
            
        } else {
            fnMuestraAlerta()
            vRetorno = "Vuelva a intentarlo por favor!"
        }
        
        if vRetorno == "{}"{
           vRetorno = "No se encontró el registro con este ISBN. Vuleva a intentarlo!"
        }
        return ([texto2,vautores,urlPorts])
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

