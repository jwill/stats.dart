#import('dart:html');
#import('dart:core');

class Stats {
  Element container, fpsDiv, fpsGraph, fpsText, msGraph, msText, bar, msDiv; 
  var fps = 0, fpsMin = 1000, fpsMax = 0;
  var ms = 0, msMin = 1000, msMax = 0;
  var fpsColors, msColors;
  var time, timeLastFrame;
  var frames = 0, timeLastSecond;
  num mode = 0, modes = 2;
  
  Stats() {
    fpsColors = [[16,16,48],[0,255,255]];
    msColors = [[16,48,16], [0,255,0]];
    time = new Date.now();
    timeLastFrame = time.value;
    timeLastSecond = time.value;
    
    createDivs();
    container.on.mouseDown.add((event) {
      event.preventDefault();
      mode = (mode + 1) % modes;
      if (mode == 0) {
        fpsDiv.style.display = 'block';
        msDiv.style.display = 'none';
      } else {
        fpsDiv.style.display = 'none';
        msDiv.style.display = 'block';
      }
    });
  }
  
  createDivs() {
    container = new Element.tag("div");
    container.style.cursor = 'pointer';
    container.style.width = '80px';
    container.style.opacity = '0.9';
    container.style.zIndex = '10001';
    
    fpsDiv = new Element.tag("div");
    fpsDiv.style.textAlign = 'left';
    fpsDiv.style.lineHeight = '1.2em';
    fpsDiv.style.backgroundColor = 'rgb(' + ( fpsColors[ 0 ][ 0 ] / 2 ).floor() + ',' + ( fpsColors[ 0 ][ 1 ] / 2 ).floor() + ',' + ( fpsColors[ 0 ][ 2 ] / 2 ).floor() + ')';
    fpsDiv.style.padding = '0 0 3px 3px';
    
    fpsText = new Element.tag('div');
    fpsText.style.fontFamily = 'Helvetica, Arial, sans-serif';
    fpsText.style.fontSize = '9px';
    fpsText.style.color = 'rgb(' + fpsColors[ 1 ][ 0 ] + ',' + fpsColors[ 1 ][ 1 ] + ',' + fpsColors[ 1 ][ 2 ] + ')';
    fpsText.style.fontWeight = 'bold';
    fpsText.innerHTML = 'FPS';
    
    fpsGraph = new Element.tag("div");
    fpsGraph.style.position = 'relative';
    fpsGraph.style.backgroundColor = 'rgb(' + fpsColors[ 1 ][ 0 ] + ',' + fpsColors[ 1 ][ 1 ] + ',' + fpsColors[ 1 ][ 2 ] + ')';
    fpsGraph.style.width = '74px';
    fpsGraph.style.height = '30px';
    
    for(var i=0; i<74; i++) {
      bar = new Element.tag('span');
      bar.style.width = '1px';
      bar.style.height = '30 px';
      bar.style.float = 'left';
      bar.style.backgroundColor = 'rgb(' + fpsColors[ 0 ][ 0 ] + ',' + fpsColors[ 0 ][ 1 ] + ',' + fpsColors[ 0 ][ 2 ] + ')';
      fpsGraph.nodes.add(bar);
    }
        
    msDiv = new Element.tag('div');
    msDiv.style.textAlign = 'left';
    msDiv.style.lineHeight = '1.2em';
    msDiv.style.padding = '0 0 3px 3px';
    msDiv.style.display = 'none';
    msDiv.style.backgroundColor = '';
    
    msText = new Element.tag('div');
    msText.style.fontFamily = 'Helvetica, Arial, sans-serif';
    msText.style.fontSize = '9px';
    msText.style.fontWeight = 'bold';
    msText.innerHTML = 'MS';
    
    msGraph = new Element.tag('div');
    msGraph.style.position = 'relative';
    msGraph.style.width = '74px';
    msGraph.style.height = '30px';
    msGraph.style.backgroundColor = 'rgb(' + msColors[ 1 ][ 0 ] + ',' + msColors[ 1 ][ 1 ] + ',' + msColors[ 1 ][ 2 ] + ')';
    
    while (msGraph.nodes.length < 74) {
      bar = new Element.tag('span');
      bar.style.width = '1px';
      bar.style.height = (Math.random() * 30).toString() + 'px';
      bar.style.float = 'left';
      bar.style.backgroundColor = 'rgb(' + msColors[ 0 ][ 0 ] + ',' + msColors[ 0 ][ 1 ] + ',' + msColors[ 0 ][ 2 ] + ')';
      msGraph.nodes.add(bar);
    }
    
    
    container.nodes.add(fpsDiv);
    container.nodes.add(msDiv);
    
    fpsDiv.nodes.add(fpsText);
    fpsDiv.nodes.add(fpsGraph);
    
    msDiv.nodes.add(msText);
    msDiv.nodes.add(msGraph);
  }
  
  getDomElement() => container;
  getFps() => fps;
  getFpsMin() => fpsMin;
  getFpsMax() => fpsMax;
  getMs() => ms;
  getMsMin() => msMin;
  getMsMax() => msMax;
  
  updateGraph(Element dom, value) {
    var firstChild = dom.elements.first;
    firstChild.style.height = value.toString() + 'px';
    dom.nodes.add(firstChild);
  }
  
  update() {
    time = new Date.now().value;
    
    ms = time - timeLastFrame;
    msMin = Math.min( msMin, ms );
    msMax = Math.max( msMax, ms );

    msText.text = ms.toString() + ' MS (' + msMin + '-' + msMax + ')';
    updateGraph( msGraph, Math.min( 30, 30 - ( ms / 200 ) * 30 ) );

    timeLastFrame = time;

    frames++;

    if ( time > timeLastSecond + 1000 ) {

      fps = ( ( frames * 1000 ) / ( time - timeLastSecond ) ).round().toInt();
      fpsMin = Math.min( fpsMin, fps );
      fpsMax = Math.max( fpsMax, fps );

      fpsText.text = fps.toString() + ' FPS (' + fpsMin + '-' + fpsMax + ')';
      updateGraph( fpsGraph, Math.min( 30, 30 - ( fps / 100 ) * 30 ) );

      timeLastSecond = time;
      frames = 0;

    }

  }
  
  bool animate(time) {
    window.webkitRequestAnimationFrame(animate);
    this.render(time);
  }
  
  render(time) {
    this.update();
  }
  

  void run() {
    document.query('body').nodes.add(container);
    animate(0);
  }
}

void main() {
  new Stats().run();
}
