const RES = (typeof GetParentResourceName === 'function') ? GetParentResourceName() : '3m_dealership';
function postNUI(name, data){
  return fetch(`https://${RES}/${name}`, {
    method:'POST',
    headers:{'Content-Type':'application/json; charset=UTF-8'},
    body: JSON.stringify(data||{})
  }).then(r=>{ try{ return r.json(); }catch(_){ return {}; } }).catch(()=>({}));
}


var I18N = { locale: 'hr', dict: {} };
function _fmt(str, args){
  if (!args || !args.length) return str;
  var i = 0;
  return String(str).replace(/%s/g, function(){ return (i < args.length ? String(args[i++]) : ''); });
}
function L(key ){
  var args = Array.prototype.slice.call(arguments, 1);
  var str = (I18N.dict && I18N.dict[key]) || key;
  return _fmt(str, args);
}
function Ldef(key, fallback ){
  var args = Array.prototype.slice.call(arguments, 2);
  var str = (I18N.dict && I18N.dict[key]) || fallback || key;
  return _fmt(str, args);
}
function applyI18nRoot(){
  var nodes = document.querySelectorAll('[data-i18n]');
  for (var i=0;i<nodes.length;i++){
    var el = nodes[i];
    var key = el.getAttribute('data-i18n');
    var mode = el.getAttribute('data-i18n-attr') || 'text';
    var val = Ldef(key, el.getAttribute('data-i18n-fallback') || el.textContent || '');
    if (mode === 'placeholder') el.setAttribute('placeholder', val);
    else if (mode === 'value')  el.setAttribute('value', val);
    else el.textContent = val;
  }
  var options = document.querySelectorAll('option[data-i18n]');
  for (var j=0;j<options.length;j++){
    var o = options[j];
    o.textContent = Ldef(o.getAttribute('data-i18n'), o.getAttribute('data-i18n-fallback') || o.textContent || '');
  }
  var tabs = document.querySelectorAll('.tab[data-i18n]');
  for (var k=0;k<tabs.length;k++){
    var t = tabs[k];
    t.textContent = Ldef(t.getAttribute('data-i18n'), t.getAttribute('data-i18n-fallback') || t.textContent || '');
  }
}


function hardFocus(){
  postNUI('focus', {});
  requestAnimationFrame(() => postNUI('focus', {}));
}

function releaseFocus(){
  postNUI('focusOff', {});
  setTimeout(() => postNUI('focusOff', {}), 0);
}
function isAppVisible(){
  return (app && !app.classList.contains('hidden'));
}



try{ document.addEventListener('visibilitychange', function(){ if (document.hidden) releaseFocus(); }); }catch(_){}
function closeAllUI(){
  if (buyOverlay)  buyOverlay.classList.add('hidden');
  if (testOverlay) testOverlay.classList.add('hidden');
  if (viewOverlay) viewOverlay.classList.add('hidden');
  if (usedOverlay) usedOverlay.classList.add('hidden');
  if (app)         app.classList.add('hidden');
}

function anyModalOpen(){
  return (buyOverlay && !buyOverlay.classList.contains('hidden'))
      || (testOverlay && !testOverlay.classList.contains('hidden'))
      || (viewOverlay && !viewOverlay.classList.contains('hidden'))
      || (usedOverlay && !usedOverlay.classList.contains('hidden'));
}


window.modelLabelByPlate = window.modelLabelByPlate || Object.create(null);


var app      = document.getElementById('app');
var q        = document.getElementById('q');
var sortSel  = document.getElementById('sort');
var catsEl   = document.getElementById('cats');
var listEl   = document.getElementById('list');

var selLabel = document.getElementById('selLabel');
var selMeta  = document.getElementById('selMeta');
var selPrice = document.getElementById('selPrice');

var colorP   = document.getElementById('colorP');
var colorS   = document.getElementById('colorS');
var rgbP     = document.getElementById('rgbP');
var rgbS     = document.getElementById('rgbS');
var applyP   = document.getElementById('applyP');
var applyS   = document.getElementById('applyS');
var presetsP = document.getElementById('presetsP');
var presetsS = document.getElementById('presetsS');

var btnClose = document.getElementById('btn-close');
var rotL     = document.getElementById('rotL');
var rotR     = document.getElementById('rotR');
var orbitSw  = document.getElementById('orbitSwitch');

var sidebar  = document.querySelector('.sidebar');
var floatPan = document.querySelector('.float-panel');

var finBox    = document.getElementById('finBox');
var instMinus = document.getElementById('instMinus');
var instPlus  = document.getElementById('instPlus');
var instVal   = document.getElementById('instVal');
var finSim    = document.getElementById('finSim');
var finDown   = document.getElementById('finDown');

var viewOverlay = document.getElementById('viewOverlay');
var viewTitle   = document.getElementById('viewTitle');
var viewModel   = document.getElementById('viewModel');
var viewCat     = document.getElementById('viewCat');
var viewPrice   = document.getElementById('viewPrice');
var viewClose   = document.getElementById('viewClose');
var viewClose2  = document.getElementById('viewClose2');

var buyOverlay  = document.getElementById('buyOverlay');
var buyTitle    = document.getElementById('buyTitle');
var buyBody     = document.getElementById('buyBody');
var buyClose    = document.getElementById('buyClose');
var buyCancel   = document.getElementById('buyCancel');
var buyConfirm  = document.getElementById('buyConfirm');

var testOverlay = document.getElementById('testOverlay');
var testTitle   = document.getElementById('testTitle');
var testModelEl = document.getElementById('testModel');
var testDurEl   = document.getElementById('testDur');
var testClose   = document.getElementById('testClose');
var testCancel  = document.getElementById('testCancel');
var testConfirm = document.getElementById('testConfirm');

var ALL = [];
var FILTERED = [];
var ACTIVE_CAT = null;
var ACTIVE = null;
var PRICE_CACHE = {};
var FINCFG = { enabled:false, downPct:20, markupPct:5, defaultInstallments:10, min:1, max:12 };
var CURRENT_INST = 10;
var _focusPlate = null;

var SWATCHES = [
  [220,38,38],[234,88,12],[245,158,11],[22,163,74],[5,150,105],[14,165,233],
  [37,99,235],[99,102,241],[139,92,246],[236,72,153],[148,163,184],[23,23,23]
];

var LAST_P_RGB = null; 
var LAST_S_RGB = null; 


function clamp(v,a,b){ return Math.max(a, Math.min(b,v)); }
function hexToRgb(hex){
  var m = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex||'');
  if (!m) return null;             
  return [
    parseInt(m[1],16),
    parseInt(m[2],16),
    parseInt(m[3],16)
  ];
}
function parseRgbInput(s){
  if (!s) return null;
  var n = s.split(',').map(function(x){ return parseInt(x.trim(),10); });
  if (n.length!==3 || n.some(function(v){ return isNaN(v)||v<0||v>255; })) return null;
  return n;
}
function money(n){ return '$' + Number(n||0).toLocaleString(); }
function priceOf(model){
  var p = PRICE_CACHE[model];
  return typeof p === 'number' ? p : 0;
}
function prettyModelRaw(model){
  if (model == null) return 'unknown';
  return String(model);
}


function computeFinance(basePrice, inst){
  var withMarkup = Math.floor(basePrice * (FINCFG.markupPct/100 + 1));
  var down = Math.floor(withMarkup * (FINCFG.downPct/100));
  var principal = withMarkup - down;
  var per = Math.ceil(principal / (clamp(inst, FINCFG.min, FINCFG.max) || 1));
  return { withMarkup:withMarkup, down:down, per:per };
}
function updateFinanceSim(){
  if (!FINCFG.enabled || !ACTIVE) return;
  var base = priceOf(ACTIVE.model);
  var c = computeFinance(base, CURRENT_INST);
  if (finSim)   finSim.textContent  = money(c.per) + ' × ' + CURRENT_INST;
  if (finDown)  finDown.textContent = money(c.down);
}


function buildPresets(root, type){
  if (!root) return;
  root.innerHTML = '';
  for (var i=0;i<SWATCHES.length;i++){
    (function(rgb){
      var d = document.createElement('div');
      d.className = 'preset';
      d.style.background = 'rgb(' + rgb.join(',') + ')';
      d.title = 'RGB ' + rgb.join(',');
      d.onclick = function(){
        if (type === 'p') LAST_P_RGB = rgb.slice(0);
        else if (type === 's') LAST_S_RGB = rgb.slice(0);
        postNUI('colorPick', { type:type, rgb:rgb });
      };
      root.appendChild(d); 
    })(SWATCHES[i]);
  }
}



function setActive(vehicle){
  ACTIVE = vehicle;
  if (selLabel) selLabel.textContent = vehicle.label || vehicle.model;
  var cat = vehicle.category || Ldef('ui_cat_other', 'Other');
  var brand = vehicle.brand ? (' • ' + vehicle.brand) : '';
  if (selMeta) selMeta.textContent = cat + brand;
  if (selPrice) selPrice.textContent = '—';

  postNUI('modelHover', { model: vehicle.model });

  function applyPrice(p){
    PRICE_CACHE[vehicle.model] = p;
    if (ACTIVE && ACTIVE.model === vehicle.model && selPrice){
      selPrice.textContent = money(p);
      updateFinanceSim();
    }
  }

  if (PRICE_CACHE[vehicle.model] != null){
    applyPrice(PRICE_CACHE[vehicle.model]);
  } else {
    postNUI('price', { model: vehicle.model }).then(function(r){
      var p = (r && typeof r.price === 'number') ? r.price : 0;
      applyPrice(p);
    });
  }
}

function drawList(){
  if (!listEl) return;
  listEl.innerHTML = '';
  for (var i=0;i<FILTERED.length;i++){
    (function(v){
      var it = document.createElement('div');
      it.className = 'item';
      it.innerHTML =
        '<div class="meta">' +
          '<div class="name">' + (v.label || v.model) + '</div>' +
          '<div class="sub">' + (v.category || Ldef('ui_cat_other', 'Other')) + '</div>' +
        '</div>' +
        '<div class="price mono">' + (PRICE_CACHE[v.model]!=null ? money(PRICE_CACHE[v.model]) : '—') + '</div>';
      it.onclick = function(){ setActive(v); };
      listEl.appendChild(it);
    })(FILTERED[i]);
  }
}
function applyFilters(){
  var term = (q && q.value || '').toLowerCase();
  FILTERED = ALL.filter(function(v){
    if (ACTIVE_CAT && v.category !== ACTIVE_CAT && ACTIVE_CAT !== Ldef('ui_all_categories', 'Sve kategorije')) return false;
    if (!term) return true;
    return ( (v.label||v.model).toLowerCase().indexOf(term) !== -1 ) || ((v.brand||'').toLowerCase().indexOf(term) !== -1);
  });
  var how = (sortSel && sortSel.value) || 'label';
  FILTERED.sort(function(a,b){
    if (how==='price') return (PRICE_CACHE[a.model]||0) - (PRICE_CACHE[b.model]||0);
    return (a.label||a.model).localeCompare(b.label||b.model, I18N.locale || 'hr');
  });
  drawList();
}
function drawCategories(cats){
  if (!catsEl) return;
  catsEl.innerHTML = '';
  function mk(name, count){
    var div = document.createElement('div');
    div.className = 'cat';
    div.innerHTML = '<div class="title">'+name+'</div><div class="count">'+count+'</div>';
    if (ACTIVE_CAT === name){
      div.style.outline = '2px solid var(--accent)';
      div.style.boxShadow = '0 0 0 3px rgba(49,215,255,.12) inset';
    }
    div.onclick = function(){
      ACTIVE_CAT = (ACTIVE_CAT===name)? null : name;
      drawCategories(cats);
      applyFilters();
    };
    catsEl.appendChild(div);
  }
  mk(Ldef('ui_all_categories', 'Sve kategorije'), ALL.length);
  for (var i=0;i<cats.length;i++) mk(cats[i].name, cats[i].count);
}

if (btnClose) btnClose.onclick = function(){ postNUI('close', {}); };
if (rotL)     rotL.onclick     = function(){ postNUI('rotate', { dir:-1 }); };
if (rotR)     rotR.onclick     = function(){ postNUI('rotate', { dir: 1 }); };
if (orbitSw)  orbitSw.onclick  = function(){
  var on = orbitSw.getAttribute('data-on') === '1';
  var next = on ? '0' : '1';
  orbitSw.setAttribute('data-on', next);
  postNUI('setAutoOrbit', { off: next !== '1' });
};
if (q)       q.addEventListener('input', applyFilters);
if (sortSel) sortSel.addEventListener('change', applyFilters);

var buyCashBtn = document.getElementById('buyCash');
var buyFinBtn  = document.getElementById('buyFin');
var testBtn    = document.getElementById('test');

if (testBtn)    testBtn.onclick    = function(){ if (ACTIVE) openTestCard(ACTIVE.model, null); };
if (buyCashBtn) buyCashBtn.onclick = function(){ if (ACTIVE) openBuyCard(ACTIVE.model, 'cash'); };
if (buyFinBtn)  buyFinBtn.onclick  = function(){ if (ACTIVE) openBuyCard(ACTIVE.model, 'finance'); };

window.addEventListener('wheel', function(e){
  var el = e.target;
  var overSidebar  = sidebar && (el.closest && el.closest('.sidebar'));
  var overFloat    = floatPan && (el.closest && el.closest('.float-panel'));
  if (overSidebar || overFloat) return; 
  var delta = Math.sign(e.deltaY);
  postNUI('zoom', { delta: -delta });
  e.preventDefault();
}, { passive:false });


var isDragging = false, lastX = 0, dragAccum = 0;
var DRAG_DEADZONE = 2, DRAG_PX_PER_PULSE = 8;
function isOverPanel(el){ return (sidebar && el.closest && el.closest('.sidebar')) || (floatPan && el.closest && el.closest('.float-panel')); }
window.addEventListener('mousedown', function(e){
  if (e.button!==0 || isOverPanel(e.target)) return;
  isDragging=true; lastX=e.clientX; dragAccum=0; document.body.style.userSelect='none';
});
window.addEventListener('mousemove', function(e){
  if (!isDragging) return;
  if (isOverPanel(e.target)) { isDragging=false; document.body.style.userSelect=''; return; }
  var dx = e.clientX - lastX; lastX = e.clientX; dragAccum += dx;
  if (Math.abs(dragAccum) < DRAG_DEADZONE) return;
  while (Math.abs(dragAccum) >= DRAG_PX_PER_PULSE) {
    var dir = dragAccum > 0 ? 1 : -1;
    postNUI('rotate', { dir: dir });
    dragAccum -= dir * DRAG_PX_PER_PULSE;
  }
});
function stopDrag(){ if (isDragging){ isDragging=false; document.body.style.userSelect=''; } }
window.addEventListener('mouseup', stopDrag);
window.addEventListener('mouseleave', stopDrag);
window.addEventListener('blur', stopDrag);
window.addEventListener('contextmenu', function(e){ if (isDragging) e.preventDefault(); });


window.addEventListener('keydown', function(e){
  if (e.key === 'Escape'){
    if (anyModalOpen()){
      if (buyOverlay && !buyOverlay.classList.contains('hidden')) return closeBuyCard();
      if (testOverlay && !testOverlay.classList.contains('hidden')) return closeTestCard();
      if (viewOverlay && !viewOverlay.classList.contains('hidden')) return closeViewCard();
      if (usedOverlay && !usedOverlay.classList.contains('hidden')) return closeUsed();
      return;
    }
    postNUI('close', {});
    closeAllUI();
    releaseFocus();
    return;
  }
  if (e.key === 'ArrowLeft')  postNUI('rotate', { dir:-1 });
  if (e.key === 'ArrowRight') postNUI('rotate', { dir: 1 });
});


(function initPresets(){
  buildPresets(presetsP, 'p');
  buildPresets(presetsS, 's');
})();

if (applyP) applyP.onclick = function(){
  if (!ACTIVE) return;
  var rgb = parseRgbInput(rgbP && rgbP.value) || hexToRgb(colorP && colorP.value);
  if (!rgb) return;
  LAST_P_RGB = rgb.slice(0);
  postNUI('colorPick', { type:'p', rgb: rgb });
};
if (applyS) applyS.onclick = function(){
  if (!ACTIVE) return;
  var rgb = parseRgbInput(rgbS && rgbS.value) || hexToRgb(colorS && colorS.value);
  if (!rgb) return;
  LAST_S_RGB = rgb.slice(0);
  postNUI('colorPick', { type:'s', rgb: rgb });
};


function bumpInst(delta){
  if (!instVal) return;
  CURRENT_INST = clamp((parseInt(instVal.value,10) || CURRENT_INST) + delta, FINCFG.min, FINCFG.max);
  instVal.value = CURRENT_INST;
  updateFinanceSim();
}
if (instMinus) instMinus.onclick = function(){ bumpInst(-1); };
if (instPlus)  instPlus.onclick  = function(){ bumpInst( 1); };
if (instVal)   instVal.oninput   = function(){
  CURRENT_INST = clamp(parseInt(instVal.value,10) || FINCFG.defaultInstallments, FINCFG.min, FINCFG.max);
  instVal.value = CURRENT_INST;
  updateFinanceSim();
};

function openViewCardPayload(model, label, cat){
  if (viewTitle) viewTitle.textContent = Ldef('ui_view_title', 'Pregled vozila');
  if (viewModel) viewModel.textContent = label || model;
  if (viewCat)   viewCat.textContent   = cat || '—';
  if (viewPrice) viewPrice.textContent = '—';
  if (viewOverlay){
    viewOverlay.classList.remove('hidden');
    viewOverlay.setAttribute('aria-hidden','false');
  }
  hardFocus();
  function ensurePrice(){
    var p = priceOf(model);
    if (p && viewPrice) viewPrice.textContent = money(p);
    else postNUI('price', { model: model }).then(function(r){
      var pr = (r && typeof r.price === 'number') ? r.price : 0;
      PRICE_CACHE[model] = pr;
      if (viewPrice) viewPrice.textContent = money(pr);
    });
  }
  ensurePrice();
}
function closeViewCard(){
  if (viewOverlay){
    viewOverlay.classList.add('hidden');
    viewOverlay.setAttribute('aria-hidden','true');
  }
  if (isAppVisible()) hardFocus();
  else releaseFocus();
}

if (viewClose)  viewClose.onclick  = closeViewCard;
if (viewClose2) viewClose2.onclick = closeViewCard;

var _buyCtx = { model:null, method:'cash', inst:null };
function openBuyCard(model, method){
  _buyCtx = { model:model, method:method, inst: (method==='finance'? clamp(FINCFG.defaultInstallments||10, FINCFG.min, FINCFG.max) : null) };
  if (buyTitle) buyTitle.textContent = (method==='finance') ? Ldef('buy_finance', 'Financiranje') : Ldef('buy_cash', 'Kupnja');
  if (buyBody)  buyBody.innerHTML = Ldef('ui_loading', 'Učitavam…');
  if (buyOverlay){
    buyOverlay.classList.remove('hidden');
    buyOverlay.setAttribute('aria-hidden','false');
  }
  hardFocus();
  var base = priceOf(model);
  function afterPrice(p){
    if (!buyBody) return;
    if (method === 'cash'){
      buyBody.innerHTML =
        '<div class="kv">' +
          '<div class="k">'+Ldef('ui_model','Model')+'</div><div class="v mono">'+model+'</div>' +
          '<div class="k">'+Ldef('ui_method','Način')+'</div><div class="v">'+Ldef('ui_method_cash','Gotovina')+'</div>' +
          '<div class="k">'+Ldef('ui_price','Cijena')+'</div><div class="v mono">'+money(p)+'</div>' +
        '</div>';
    } else {
      var instMin = FINCFG.min, instMax = FINCFG.max;
      var calc = computeFinance(p, _buyCtx.inst);
      buyBody.innerHTML =
        '<div class="kv" style="margin-bottom:8px">' +
          '<div class="k">'+Ldef('ui_model','Model')+'</div><div class="v mono">'+model+'</div>' +
          '<div class="k">'+Ldef('ui_method','Način')+'</div><div class="v">'+Ldef('ui_method_finance','Financiranje')+'</div>' +
          '<div class="k">'+Ldef('ui_price_with_markup','Cijena s maržom')+'</div><div class="v mono">'+money(calc.withMarkup)+'</div>' +
          '<div class="k">'+Ldef('ui_pay_now','Plaćaš odmah')+'</div><div class="v mono" id="buyDown">'+money(calc.down)+'</div>' +
          '<div class="k">'+Ldef('ui_installment','Rata')+'</div><div class="v mono" id="buyPer">'+money(calc.per)+' × <span id="buyInst">'+_buyCtx.inst+'</span></div>' +
        '</div>' +
        '<div class="fin-steps">' +
          '<button class="step" id="buyInstMinus">–</button>' +
          '<input id="buyInstVal" class="input sm center" type="number" min="'+instMin+'" max="'+instMax+'" value="'+_buyCtx.inst+'" />' +
          '<button class="step" id="buyInstPlus">+</button>' +
        '</div>';
      var minus = document.getElementById('buyInstMinus');
      var plus  = document.getElementById('buyInstPlus');
      var val   = document.getElementById('buyInstVal');
      function syncCalc(){
        var inst = clamp(parseInt(val.value,10)||_buyCtx.inst, instMin, instMax);
        _buyCtx.inst = inst;
        var c = computeFinance(p, inst);
        var downEl = document.getElementById('buyDown');
        var perEl  = document.getElementById('buyPer');
        if (downEl) downEl.textContent = money(c.down);
        if (perEl)  perEl.innerHTML = money(c.per) + ' × <span id="buyInst">'+inst+'</span>';
      }
      if (minus) minus.onclick = function(){ val.value = clamp(_buyCtx.inst-1, instMin, instMax); syncCalc(); };
      if (plus)  plus.onclick  = function(){ val.value = clamp(_buyCtx.inst+1, instMin, instMax); syncCalc(); };
      if (val)   val.oninput   = syncCalc;
    }
  }
  if (base) afterPrice(base);
  else postNUI('price', { model:model }).then(function(r){
    var p = (r && typeof r.price === 'number') ? r.price : 0;
    PRICE_CACHE[model]=p; afterPrice(p);
  });
}
function closeBuyCard(){
  if (buyOverlay){
    buyOverlay.classList.add('hidden');
    buyOverlay.setAttribute('aria-hidden','true');
  }
  if (isAppVisible()) hardFocus();
  else releaseFocus();
}

if (buyClose)   buyClose.onclick  = closeBuyCard;
if (buyCancel)  buyCancel.onclick = closeBuyCard;
if (buyConfirm) buyConfirm.onclick = function(){
  if (!_buyCtx.model) return;
  buyConfirm.disabled = true;
  if (buyCancel) buyCancel.disabled = true;

    const payload = (_buyCtx.method === 'finance')
    ? { model:_buyCtx.model, method:'finance', installments:_buyCtx.inst }
    : { model:_buyCtx.model, method:'cash' };

  const props = {};
  if (LAST_P_RGB) props.customPrimaryColor = LAST_P_RGB;
  if (LAST_S_RGB) props.customSecondaryColor = LAST_S_RGB;
  if (Object.keys(props).length > 0) {
    payload.props = props;
  }


  postNUI('buy', payload).then(function(){
    closeBuyCard();          
    if (app) app.classList.add('hidden'); 
    releaseFocus();         
  }).finally(function(){
    buyConfirm.disabled = false;
    if (buyCancel) buyCancel.disabled = false;
  });
};



var _testCtx = { model:null, duration:120 };
function openTestCard(model, duration){
  _testCtx = { model:model, duration: (typeof duration==='number'? duration : _testCtx.duration) };
  if (testTitle)  testTitle.textContent = Ldef('test_drive', 'Testna vožnja');
  if (testModelEl) testModelEl.textContent = model;
  if (testDurEl)   testDurEl.textContent = _testCtx.duration;
  if (testOverlay){
    testOverlay.classList.remove('hidden');
    testOverlay.setAttribute('aria-hidden','false');
  }
  hardFocus();
}
function closeTestCard(){
  if (testOverlay){
    testOverlay.classList.add('hidden');
    testOverlay.setAttribute('aria-hidden','true');
  }
  if (isAppVisible()) hardFocus();
  else releaseFocus();
}
if (testClose)  testClose.onclick  = closeTestCard;
if (testCancel) testCancel.onclick = closeTestCard;
if (testConfirm) testConfirm.onclick = function(){
  if (!_testCtx.model) return;
  postNUI('testDrive', { model:_testCtx.model }).then(closeTestCard);
};

var _refocusedOnce = false;
window.addEventListener('message', function(ev){
  var action  = ev && ev.data && ev.data.action;
  var data    = ev && ev.data && ev.data.data;
  var payload = ev && ev.data && ev.data.payload;

  if (action === 'setLocale' && data && data.dict){
    I18N.locale = data.locale || I18N.locale;
    I18N.dict   = data.dict   || {};
    applyI18nRoot();
    return;
  }

  if (action === 'usedSyncLabelify' && ev.data && Array.isArray(ev.data.rows)) {
    for (var i=0;i<ev.data.rows.length;i++){
      var r = ev.data.rows[i];
      if (r && r.plate){
        window.modelLabelByPlate[r.plate] = r.model_label || r.model || 'unknown';
      }
    }
    return;
  }

  if (action === 'open'){
    if (app) app.classList.remove('hidden');
    hardFocus();
    ALL = (data && data.vehicles) || [];
    var cats = (data && data.categories) || [];
    if (!cats.length){
      var map = {};
      for (var i=0;i<ALL.length;i++){
        var v = ALL[i];
        var c = v.category || Ldef('ui_cat_other','Other');
        map[c] = (map[c]||0)+1;
      }
      cats = Object.keys(map).sort().map(function(name){ return {name:name, count:map[name]}; });
    }
    if (data && data.prices) for (var k in data.prices){ PRICE_CACHE[k] = data.prices[k]; }

    if (data && data.finance){
      for (var f in data.finance){ FINCFG[f] = data.finance[f]; }
      CURRENT_INST = clamp(FINCFG.defaultInstallments || 10, FINCFG.min, FINCFG.max);
      if (instVal) instVal.value = CURRENT_INST;
      if (finBox)  finBox.setAttribute('aria-hidden', FINCFG.enabled ? 'false' : 'true');
    }

    drawCategories(cats);
    FILTERED = ALL.slice(0);
    drawList();
    if (ALL[0]) setActive(ALL[0]); else updateFinanceSim();
    _refocusedOnce = false;

} else if (action === 'close'){
  closeAllUI();
  releaseFocus();
  _refocusedOnce = false;

  } else if (action === 'viewVehicle' && payload){
    var meta = null;
    for (var i=0;i<ALL.length;i++){ if (ALL[i].model === payload.model){ meta = ALL[i]; break; } }
    meta = meta || { model: payload.model, label: payload.model, category:'—' };
    openViewCardPayload(meta.model, meta.label, meta.category);

  } else if (action === 'openBuy' && payload){
    openBuyCard(payload.model, payload.method);

  } else if (action === 'openTest' && payload){
    openTestCard(payload.model, (payload && payload.duration) || null);
  }
});


window.addEventListener('pointerdown', function(){
  if (!_refocusedOnce && app && !app.classList.contains('hidden')) {
    _refocusedOnce = true;
    hardFocus();
  }
}, { passive:true });


document.addEventListener('visibilitychange', function(){
  if (!document.hidden && app && !app.classList.contains('hidden')) hardFocus();
});
window.addEventListener('blur', function(){
  if (app && !app.classList.contains('hidden')) setTimeout(hardFocus, 0);
});


postNUI('nuiReady', {}).then(function(){});


var usedOverlay = document.getElementById('usedOverlay');
var usedClose   = document.getElementById('usedClose');
var usedClose2  = document.getElementById('usedClose2');
var usedTabs    = document.getElementById('usedTabs');

var paneBrowse  = document.getElementById('usedBrowse');
var paneSell    = document.getElementById('usedSell');
var paneMine    = document.getElementById('usedMine');

var usedGrid    = document.getElementById('usedGrid');
var usedRefresh = document.getElementById('usedRefresh');

var sellVehicle = document.getElementById('sellVehicle');
var sellPrice   = document.getElementById('sellPrice');
var sellDesc    = document.getElementById('sellDesc');
var sellSlot    = document.getElementById('sellSlot');
var sellConfirm = document.getElementById('sellConfirm');

var mineList    = document.getElementById('mineList');
var mineRefresh = document.getElementById('mineRefresh');
var claimPayout = document.getElementById('claimPayout');

function usedTabShow(id){
  if (paneBrowse) paneBrowse.classList.add('hidden');
  if (paneSell)   paneSell.classList.add('hidden');
  if (paneMine)   paneMine.classList.add('hidden');
  if (id==='browse' && paneBrowse) paneBrowse.classList.remove('hidden');
  if (id==='sell'   && paneSell)   paneSell.classList.remove('hidden');
  if (id==='mine'   && paneMine)   paneMine.classList.remove('hidden');
  if (usedTabs){
    var buttons = usedTabs.querySelectorAll('.tab');
    for (var i=0;i<buttons.length;i++){
      var btn = buttons[i];
      btn.classList.toggle('active', btn.getAttribute('data-tab')===id);
    }
  }
}

function openUsed(tab, focusPlate){
  if (focusPlate) _focusPlate = String(focusPlate);
  if (usedOverlay){
    usedOverlay.classList.remove('hidden');
    usedOverlay.setAttribute('aria-hidden','false');
  }
  hardFocus();
  usedTabShow(tab || 'browse');
  refreshBrowse().then(function(){
    if (_focusPlate && usedGrid){
      var el = usedGrid.querySelector('.used-card[data-plate="'+_focusPlate+'"]');
      if (el){
        el.classList.add('highlight');
        try { el.scrollIntoView({behavior:'auto', block:'center'}); } catch(_) {}
        setTimeout(function(){ el.classList.remove('highlight'); }, 1600);
      }
      _focusPlate = null;
    }
  });
}
function closeUsed(){
  if (usedOverlay){
    usedOverlay.classList.add('hidden');
    usedOverlay.setAttribute('aria-hidden','true');
  }
  postNUI('used:focusOff', {}); 
  if (isAppVisible()) hardFocus();
  else releaseFocus();
}

if (usedClose)  usedClose.onclick  = closeUsed;
if (usedClose2) usedClose2.onclick = closeUsed;
if (usedTabs) usedTabs.addEventListener('click', function(e){
  var b = e.target.closest && e.target.closest('.tab'); if (!b) return;
  usedTabShow(b.getAttribute('data-tab'));
  var id = b.getAttribute('data-tab');
  if (id === 'browse') refreshBrowse();
  if (id === 'sell')   prepSellForm();
  if (id === 'mine')   refreshMine();
});


function prettyByPlate(plate, fallbackModel){
  var lbl = window.modelLabelByPlate && window.modelLabelByPlate[plate];
  return lbl || prettyModelRaw(fallbackModel);
}

function cardEl(row){
  var d = document.createElement('div');
  var nice = prettyByPlate(row.plate, row.model);
  d.className = 'used-card';
  d.innerHTML =
    '<div class="used-top">' +
      '<div>' +
        '<div class="used-model">'+nice+'</div>' +
        '<div class="used-plate">'+(row.plate || '')+' • '+Ldef('consign_slot_num','Slot #%s', row.slot_index || '-')+'</div>' +
      '</div>' +
      '<div class="used-price mono">'+money(row.price||0)+'</div>' +
    '</div>' +
    '<div class="used-desc">'+ (row.description && row.description.length ? row.description : ('<span class="dim">'+Ldef('ui_no_desc','Nema opisa.')+'</span>')) +'</div>' +
    '<div class="used-actions">' +
      '<button class="btn primary">'+Ldef('buy_used','Kupi')+'</button>' +
    '</div>';
  var btn = d.querySelector('.btn.primary');
  if (btn) btn.onclick = function(){ postNUI('used:buy', { plate: row.plate }); };
  return d;
}

function refreshBrowse(){
  if (!usedGrid){ return Promise.resolve(); }
  usedGrid.innerHTML = '<div class="dim">'+Ldef('ui_loading','Učitavam…')+'</div>';
  return postNUI('used:listings', {}).then(function(res){
    var rows = (res && res.rows) || [];
    usedGrid.innerHTML = '';
    if (!rows.length){ usedGrid.innerHTML = '<div class="dim">'+Ldef('ui_used_empty','Nema aktivnih oglasa.')+'</div>'; return; }
    for (var i=0;i<rows.length;i++){
      var card = cardEl(rows[i]);
      if (rows[i].plate) card.setAttribute('data-plate', rows[i].plate);
      usedGrid.appendChild(card);
    }
  });
}
if (usedRefresh) usedRefresh.onclick = refreshBrowse;

function prepSellForm(){
  if (sellVehicle) sellVehicle.innerHTML = '<option>'+Ldef('ui_loading','Učitavam…')+'</option>';
  if (sellPrice) sellPrice.value = '';
  if (sellDesc)  sellDesc.value  = '';
  if (sellSlot)  sellSlot.value  = '';

  postNUI('used:owned', {}).then(function(res){
    var owned = (res && res.owned) || [];
    var maxS  = (res && res.maxSlots) || 1;

    if (sellVehicle){
      sellVehicle.innerHTML = '';
      if (!owned.length){
        var opt = document.createElement('option');
        opt.textContent = Ldef('ui_no_vehicles','Nemaš vozila');
        opt.value = '';
        sellVehicle.appendChild(opt);
      } else {
        for (var i=0;i<owned.length;i++){
          var v = owned[i];
          var opt2 = document.createElement('option');
          opt2.value = v.plate;
          var nice = v.model_label || (window.modelLabelByPlate && window.modelLabelByPlate[v.plate]) || String(v.model);
          opt2.textContent = nice + ' [' + v.plate + ']';
          sellVehicle.appendChild(opt2);
        }
      }
    }
    if (sellSlot){
      sellSlot.min = 1;
      sellSlot.max = Math.max(1, maxS);
    }
  });
}

if (sellConfirm) sellConfirm.onclick = function(){
  var plate = sellVehicle && sellVehicle.value;
  var price = parseInt(sellPrice && sellPrice.value, 10) || 0;
  var desc  = ((sellDesc && sellDesc.value) || '').slice(0, 300);
  var slot  = parseInt(sellSlot && sellSlot.value, 10) || 1;
  if (!plate) return;
  if (price <= 0) return;
  postNUI('used:create', { plate: plate, price: price, description: desc, slot_index: slot }).then(function(){
    usedTabShow('mine');
    refreshMine();
  });
};

function rowMine(r){
  var d = document.createElement('div');
  var nice = prettyByPlate(r.plate, r.model);
  d.className = 'row';
  d.innerHTML =
    '<div class="meta">' +
      '<div class="t">'+nice+' <span class="mono">['+(r.plate||'')+']</span></div>' +
      '<div class="s">'+Ldef('ui_slot_and_price','Slot #%s • %s', r.slot_index || '-', money(r.price||0))+'</div>' +
      '<div class="s">'+(r.description || '')+'</div>' +
    '</div>' +
    '<div class="used-actions">' +
      '<button class="btn ghost">'+Ldef('remove_consign','Ukloni vozilo sa prodaje')+'</button>' +
    '</div>';
  var btn = d.querySelector('.btn.ghost');
  if (btn) btn.onclick = function(){ postNUI('used:remove', { plate: r.plate }); };
  return d;
}
function refreshMine(){
  if (!mineList){ return; }
  mineList.innerHTML = '<div class="dim">'+Ldef('ui_loading','Učitavam…')+'</div>';
  postNUI('used:owned', {}).then(function(res){
    var my = (res && res.my) || [];
    mineList.innerHTML = '';
    if (!my.length){ mineList.innerHTML = '<div class="dim">'+Ldef('ui_no_listings','Nemaš aktivnih oglasa.')+'</div>'; return; }
    for (var i=0;i<my.length;i++) mineList.appendChild(rowMine(my[i]));
  });
}
if (mineRefresh) mineRefresh.onclick = refreshMine;
if (claimPayout) claimPayout.onclick = function(){ postNUI('used:claim', {}); };

window.addEventListener('message', function(ev){
  var action  = ev && ev.data && ev.data.action;
  var payload = ev && ev.data && ev.data.payload;
  if (action === 'usedOpen'){
    openUsed(payload && payload.tab, payload && payload.focusPlate);
  }
});
