package
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	public class WineGlassVolume extends Sprite
	{
		
		private var images:Array = [];
		private var defaults:Object = {};
		private var defaultTally:int = 0;
		private var fileList:Array = "R125.png,R175.png,R250.png,A.png,A_1.png,A_10.png,A_11.png,A_12.png,A_13.png,A_14.png,A_15.png,A_16.png,A_17.png,A_18.png,A_19.png,A_2.png,A_20.png,A_21.png,A_22.png,A_23.png,A_24.png,A_25.png,A_26.png,A_27.png,A_28.png,A_29.png,A_3.png,A_30.png,A_31.png,A_32.png,A_33.png,A_34.png,A_35.png,A_36.png,A_37.png,A_38.png,A_39.png,A_4.png,A_40.png,A_41.png,A_42.png,A_43.png,A_44.png,A_45.png,A_46.png,A_47.png,A_48.png,A_49.png,A_5.png,A_50.png,A_51.png,A_52.png,A_53.png,A_54.png,A_55.png,A_56.png,A_57.png,A_58.png,A_59.png,A_6.png,A_60.png,A_61.png,A_62.png,A_63.png,A_64.png,A_65.png,A_66.png,A_67.png,A_7.png,B.png,B_10.png,B_11.png,B_12.png,B_13.png,B_14.png,B_15.png,B_16.png,B_17.png,B_18.png,B_19.png,B_2.png,B_20.png,B_21.png,B_22.png,B_23.png,B_24.png,B_25.png,B_26.png,B_27.png,B_28.png,B_29.png,B_3.png,B_30.png,B_31.png,B_32.png,B_33.png,B_34.png,B_35.png,B_36.png,B_37.png,B_38.png,B_39.png,B_4.png,B_40.png,B_41.png,B_42.png,B_43.png,B_44.png,B_45.png,B_46.png,B_47.png,B_48.png,B_49.png,B_5.png,B_50.png,B_51.png,B_52.png,B_53.png,B_54.png,B_55.png,B_56.png,B_57.png,B_58.png,B_59.png,B_6.png,B_60.png,B_61.png,B_62.png,B_63.png,B_64.png,B_65.png,B_66.png,B_67.png,B_68.png,B_69.png,B_7.png,B_70.png,B_71.png,B_72.png,B_73.png,B_74.png,B_75.png,B_76.png,B_77.png,B_78.png,B_79.png,B_8.png,B_80.png,B_81.png,B_82.png,B_83.png,B_9.png,C.png,C_1.png,C_10.png,C_11.png,C_12.png,C_13.png,C_14.png,C_15.png,C_16.png,C_17.png,C_18.png,C_19.png,C_2.png,C_20.png,C_21.png,C_22.png,C_23.png,C_24.png,C_25.png,C_26.png,C_27.png,C_28.png,C_29.png,C_3.png,C_30.png,C_31.png,C_32.png,C_33.png,C_34.png,C_35.png,C_36.png,C_37.png,C_38.png,C_39.png,C_4.png,C_40.png,C_41.png,C_42.png,C_43.png,C_44.png,C_45.png,C_46.png,C_47.png,C_48.png,C_49.png,C_5.png,C_50.png,C_51.png,C_52.png,C_53.png,C_54.png,C_55.png,C_56.png,C_57.png,C_58.png,C_59.png,C_6.png,C_60.png,C_61.png,C_62.png,C_63.png,C_64.png,C_65.png,C_66.png,C_67.png,C_68.png,C_69.png,C_7.png,C_70.png,C_71.png,C_72.png,C_73.png,C_74.png,C_75.png,C_76.png,C_77.png,C_78.png,C_79.png,C_8.png,C_80.png,C_81.png,C_82.png,C_83.png,C_9.png".split(",");
		
		public function WineGlassVolume()
		{
			
			var image:Image;
			var loader:Loader;
			
			for each(var filename:String in fileList){

				loader = new Loader();

				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, fileLoadedL);
				loader.load(new URLRequest(File.applicationDirectory.resolvePath("stim/" + filename).url));
				
			}
		
			function fileLoadedL(e:Event):void{
				e.currentTarget.removeEventListener(e.type, arguments.callee);
				var info:LoaderInfo = e.target as LoaderInfo;
				var image:Image = new Image(info);
				
				if(image.name.indexOf("_")==-1){
					defaults[image.name] = new Default(image);
					defaultTally ++;
				}
				else images[images.length] = image;

				if(images.length+defaultTally==fileList.length) finishedLoading();
			}
		}
		
		private function finishedLoading():void
		{
			
			images.sortOn(["id","defaultType"], Array.NUMERIC);
			computeDefaultVolumes();
			computeHeights();
			
			computeVolumes();
		}
		
		private function computeVolumes():void
		{
			var defaultType:String;
			var image:Image;
			var output:Array = [['type','num','wineHeight','voxel_volume','pixels','filename'].join("\t")];
			
			for(var i:int=0;i<images.length;i++){
				image = images[i]	
				
				if(image.wineHeight!=-1){ //used during development as whole process takes >10 seconds
					
					defaultType = image.defaultType;

					image.giveVals( (defaults[defaultType] as Default).giveVolume(image.wineHeight) );
					
					output.push(image.output());
				}	
			}

			var d:Default;
			for(var key:String in defaults){

				d = defaults[key] as Default;
				output.push(d.output());
			}
			
			trace(output.join("\n"));
		}
		
		private function computeHeights():void
		{
			for each(var image:Image in images){
				image.computeHeight();
				//break;
			}
		}
		
		private function computeDefaultVolumes():void
		{
			for(var key:String in defaults){
				(defaults[key] as Default).computeSlices();
			}			
		}
	}
}




import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.filesystem.File;



class Image{
	public var name:String;
	public var id:int;
	public var bitmap:Bitmap;
	public var rows:Array;
	public var wineHeight:int = -1;
	public var volume:int;
	public var area:int;
	public var defaultType:String;
	
	public function Image(info:LoaderInfo):void{
		this.name = processName(info.url);
		this.id = processID(name);
		this.defaultType = name.substr(0,1);
		this.bitmap = info.content as Bitmap;

	}
	
	private function processID(name:String):int
	{
		var arr:Array = name.split("_");
		if(arr.length>1) return int(arr[1]);
		return -1;
	}
	
	private function processName(url:String):String
	{
		var arr:Array = url.split("/");
		return arr[arr.length-1].split(".")[0];
	}	
	
	
	public function computeSlices():void
	{
		var bd:BitmapData = bitmap.bitmapData;
		
		
		var w:int = bd.width;
		var h:int = bd.height;
		
		rows = [];
		for(var i:int=0;i<h;i++){
			rows[i] = 0;
		}
		
		i = w * h;
		
		var x:int, y:int, col:int;
		
		while ( i-- )
		{
			x = i % w;
			y = int(i / w);
			
			//gets the current color of the pixel
			col = bd.getPixel( x, y );
			
			if ( col > 0 ) { //not transparent
				rows[y]++;
			}
			
		}
	
		
	}
	
	public function computeHeight():void
	{
		computeSlices();
		
		var greaterZero:int = -1;
		
		for(var i:int=0;i<rows.length;i++){
			if(rows[i]>0 && greaterZero==-1){
				wineHeight=i+5;
				return;
			}
		}

		
	}
	
	public function output():String
	{
		return([defaultType,id,wineHeight,volume,area, name].join("\t"));
		
	}
	
	public function giveVals(params:Object):void
	{
		this.area = params.area;
		this.volume = params.vol;
		
	}
}

class Default {
	public var bitmap:Bitmap;
	private var image:Image;
	private var volumes:Array = [];
	private var vol:int = 0;
	
	public function Default(image:Image){
		this.bitmap = image.bitmap;
		this.image = image;
	}
	
	public function giveVolume(wineHeight:int):Object{
		
		var vol:int = 0;
		var rowVolume:int;
		
		
		for(var i:int=wineHeight;i<volumes.length;i++){
			rowVolume = volumes[i];
			vol += rowVolume;
			if(rowVolume==0) break;
		}
		
		var area:int = 0;
		var rowArea:int;
		for(i=wineHeight;i<image.rows.length;i++){
			rowArea = image.rows[i];
			area += rowArea;
			if(rowArea==0) break;
		}
		
		return {vol:vol, area:area};
	}
	

	public function computeSlices():void
	{
		image.computeSlices();
		computeVolumes();
		
		
		for(var i:int=0;i<volumes.length;i++){
			vol+=volumes[i];
		}
	}
	
	private function computeVolumes():void
	{
		var pixels:int;
		var vol:Number;
		for(var i:int=0;i<image.rows.length;i++){
			pixels = image.rows[i];
			if(pixels==0)	volumes[i] = 0;
			else{
				//pi r square
				volumes[i] = pixels * pixels * Math.PI;
			}
		}
		
	}
	
	public function output():Object
	{


		return (['ref','ref',-1,vol,-1, image.name].join("\t"));
	}
}
