(function(){
var sec=document.getElementById('ap-story');if(!sec)return;
var cv=sec.querySelector('canvas'),cx=cv.getContext('2d');
var q=function(c){return sec.querySelector(c)};
var K=q('.ap-k'),H=q('.ap-h'),S=q('.ap-s'),B=q('.ap-bar i'),SK=q('.ap-skip'),T=q('.ap-txt');
var D={
PL:{h:'Aplikacje, które żyją w kieszeni.',s:'Od pomysłu do sklepu — w jednym telefonie.',c:'Poznaj nasze projekty ↓',sk:'Pomiń intro',st:[['Pomysł','Każda aplikacja zaczyna się od jednej myśli.'],['Kod','Kotlin, Compose i CI — pełna kontrola.'],['Design','Interfejs, który czuć w dłoni.'],['Start','Publikacja i życie w sklepie.']]},
RU:{h:'Приложения, которые живут в кармане.',s:'От идеи до магазина — в одном телефоне.',c:'Смотри наши проекты ↓',sk:'Пропустить',st:[['Идея','Каждое приложение начинается с одной мысли.'],['Код','Kotlin, Compose и CI — всё под контролем.'],['Дизайн','Интерфейс, который чувствуешь рукой.'],['Запуск','Публикация и жизнь в магазине.']]},
EN:{h:'Apps that live in your pocket.',s:'From idea to store — inside one phone.',c:'See our projects ↓',sk:'Skip intro',st:[['Idea','Every app starts with a single thought.'],['Code','Kotlin, Compose and CI — fully in control.'],['Design','An interface you can feel in your hand.'],['Launch','Published and living in the store.']]},
RO:{h:'Aplicații care trăiesc în buzunar.',s:'De la idee la magazin — într-un singur telefon.',c:'Vezi proiectele noastre ↓',sk:'Sari peste intro',st:[['Idee','Orice aplicație începe cu o singură idee.'],['Cod','Kotlin, Compose și CI — control deplin.'],['Design','O interfață pe care o simți în mână.'],['Lansare','Publicată și vie în magazin.']]},
UK:{h:'Додатки, що живуть у кишені.',s:'Від ідеї до магазину — в одному телефоні.',c:'Дивись наші проєкти ↓',sk:'Пропустити',st:[['Ідея','Кожен додаток починається з однієї думки.'],['Код','Kotlin, Compose і CI — повний контроль.'],['Дизайн','Інтерфейс, який відчуваєш рукою.'],['Запуск','Публікація і життя в магазині.']]}};
var RM=window.matchMedia&&matchMedia('(prefers-reduced-motion: reduce)').matches;
var W=0,Hh=0,dpr=1,cur=0,tgt=0,raf=0,sc=100,ox=0,oy=0,shK=-9,shL='',tm=0;
function lang(){try{var s=localStorage.getItem('apstudio_lang');if(s&&D[s])return s;var l=(navigator.language||'pl').toLowerCase();if(l.indexOf('ru')==0)return'RU';if(l.indexOf('en')==0)return'EN';if(l.indexOf('ro')==0)return'RO';if(l.indexOf('uk')==0||l.indexOf('ua')==0)return'UK'}catch(e){}return'PL'}
function clamp(v,a,b){return v<a?a:v>b?b:v}
function sm(a,b,x){x=clamp((x-a)/(b-a),0,1);return x*x*(3-2*x)}
function phase(p){return p<.16?-1:p>=.84?4:Math.floor((p-.16)/.17)}
function size(){dpr=Math.min(window.devicePixelRatio||1,2);W=cv.clientWidth;Hh=cv.clientHeight;cv.width=Math.round(W*dpr);cv.height=Math.round(Hh*dpr)}
function rr(x,y,w,h,r){cx.beginPath();cx.moveTo(x+r,y);cx.arcTo(x+w,y,x+w,y+h,r);cx.arcTo(x+w,y+h,x,y+h,r);cx.arcTo(x,y+h,x,y,r);cx.arcTo(x,y,x+w,y,r);cx.closePath()}
function layer(i,z,on){
 cx.setTransform(dpr*sc,dpr*sc*.5,-dpr*sc*.55,dpr*sc*.5,dpr*ox,dpr*(oy-z*sc));
 cx.lineWidth=(on?2.6:1.4)/sc;cx.strokeStyle=on?'#4FD0FF':'rgba(190,205,255,.3)';
 cx.shadowColor='#4FD0FF';cx.shadowBlur=on?22*dpr:0;
 if(i==0){rr(-.5,-1,1,2,.16);cx.fillStyle='#101936';cx.fill();cx.stroke();cx.shadowBlur=0;rr(-.42,-.92,.84,1.84,.12);cx.strokeStyle='rgba(190,205,255,.14)';cx.stroke();cx.beginPath();cx.arc(-.28,-.78,.07,0,7);cx.fillStyle='rgba(79,208,255,.5)';cx.fill()}
 else if(i==1){rr(-.36,-.62,.72,1.2,.07);cx.fillStyle='#16214a';cx.fill();cx.stroke();cx.shadowBlur=0;cx.strokeStyle='rgba(190,205,255,.18)';for(var k=1;k<4;k++){cx.beginPath();cx.moveTo(-.36,-.62+k*.3);cx.lineTo(.36,-.62+k*.3);cx.stroke()}}
 else if(i==2){rr(-.44,-.9,.88,1.8,.1);cx.fillStyle='#0f2236';cx.fill();cx.stroke();cx.shadowBlur=0;
  var c=[[-.32,-.72,.34,.3],[.1,-.72,.22,.2],[-.32,-.22,.22,.22],[-.02,-.12,.34,.42],[-.32,.4,.64,.18]];
  for(var j=0;j<c.length;j++){rr(c[j][0],c[j][1],c[j][2],c[j][3],.03);cx.fillStyle='rgba(79,208,255,.16)';cx.fill();cx.strokeStyle='rgba(79,208,255,.6)';cx.lineWidth=1.2/sc;cx.stroke()}
  cx.beginPath();cx.moveTo(.02,-.52);cx.lineTo(.2,-.52);cx.lineTo(.2,-.12);cx.moveTo(-.2,-.0);cx.lineTo(-.2,.4);cx.stroke()}
 else if(i==3){rr(-.46,-.94,.92,1.88,.12);var g=cx.createLinearGradient(-.46,-.94,.46,.94);g.addColorStop(0,'#4FD0FF');g.addColorStop(1,'#7C5CFF');cx.globalAlpha=.92;cx.fillStyle=g;cx.fill();cx.globalAlpha=1;cx.stroke();cx.shadowBlur=0;
  rr(-.34,-.8,.5,.08,.04);cx.fillStyle='rgba(255,255,255,.88)';cx.fill();
  rr(-.34,-.62,.68,.42,.07);cx.fillStyle='rgba(12,19,41,.55)';cx.fill();
  rr(-.34,-.12,.68,.3,.07);cx.fill();rr(-.34,.26,.32,.3,.07);cx.fill();rr(.02,.26,.32,.3,.07);cx.fill();
  cx.beginPath();cx.arc(0,.78,.07,0,7);cx.fillStyle='rgba(255,255,255,.9)';cx.fill()}
 else{rr(-.5,-1,1,2,.16);cx.fillStyle='rgba(255,255,255,.05)';cx.fill();cx.stroke();cx.shadowBlur=0;rr(-.5,-1,1,2,.16);var h=cx.createLinearGradient(-.5,-1,.1,.3);h.addColorStop(0,'rgba(255,255,255,.22)');h.addColorStop(1,'rgba(255,255,255,0)');cx.fillStyle=h;cx.fill()}
 cx.shadowBlur=0}
function text(k,lg){
 var d=D[lg],a,b,c;
 if(k<0){a='AP STUDIO';b=d.h;c=d.s}
 else if(k>3){a='AP STUDIO';b='FinArs · WayArs';c=d.c}
 else{a='0'+(k+1)+' / 04';b=d.st[k][0];c=d.st[k][1]}
 clearTimeout(tm);T.classList.add('out');
 tm=setTimeout(function(){K.textContent=a;H.textContent=b;S.textContent=c;T.classList.remove('out')},150)}
function render(){
 var lg=lang(),k=RM?-1:phase(cur);
 if(k!==shK||lg!==shL){var first=shK==-9;shK=k;shL=lg;SK.textContent=D[lg].sk;
  if(first){var d=D[lg];K.textContent='AP STUDIO';H.textContent=d.h;S.textContent=d.s}else text(k,lg)}
 B.style.width=(cur*100)+'%';
 cx.setTransform(1,0,0,1,0,0);cx.clearRect(0,0,cv.width,cv.height);
 var wide=W>=860,e=RM?.8:sm(.08,.34,cur)-sm(.84,.98,cur);
 ox=W*(wide?.66:.5);oy=Hh*(wide?.5:.33);
 sc=Math.min((wide?W*.46:W*.86)/2.2,Hh*(wide?.8:.52)/4.15);
 var g=.05+.5*e,fl=Math.sin(cur*Math.PI*2)*.05*e,act=[0,2,3,4][k]===undefined?-1:[0,2,3,4][k];
 for(var i=0;i<5;i++)layer(i,(i-2)*g+fl,act===i||k>3)}
function loop(){raf=0;cur+=(tgt-cur)*.14;if(Math.abs(tgt-cur)<.0004)cur=tgt;render();if(cur!==tgt)kick()}
function kick(){if(!raf)raf=requestAnimationFrame(loop)}
function onS(){var r=sec.getBoundingClientRect(),tot=sec.offsetHeight-window.innerHeight;
 tgt=RM?.5:clamp(-r.top/Math.max(tot,1),0,1);
 if(r.bottom<0||r.top>window.innerHeight){cur=tgt;return}kick()}
SK.onclick=function(){var r=document.getElementById('root');if(r)r.scrollIntoView({behavior:RM?'auto':'smooth',block:'start'})};
window.addEventListener('scroll',onS,{passive:true});
window.addEventListener('resize',function(){size();onS();render()});
setInterval(function(){if(lang()!==shL)kick()},800);
sec.classList.add('on');size();onS();cur=tgt;render();
})();
