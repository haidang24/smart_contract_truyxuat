/* global window, fetch */

(function () {
  const address = window.APP_CONFIG.address;
  const chainId = window.APP_CONFIG.chainId;
  const FALLBACK_RPC = "https://rpc.zeroscan.org"; // Hardcoded RPC

  let abi;
  const $ = (id) => document.getElementById(id);
  const stringifySafe = (data) => JSON.stringify(data, (key, value) => typeof value === 'bigint' ? value.toString() : value, 2);
  const out = (id, data) => { $(id).textContent = typeof data === 'string' ? data : stringifySafe(data); };
  const show = (el, yes) => el.classList[yes ? 'add' : 'remove']('show');
  const toastEl = $('toast');
  const toast = (msg, type = 'success') => { toastEl.textContent = msg; toastEl.className = `toast show ${type}`; setTimeout(() => toastEl.classList.remove('show'), 2200); };

  async function loadAbi() { const j = await fetch('abi.json').then(r => r.json()); abi = j.abi; }

  const contractAddressEl = $('contractAddress');
  contractAddressEl.textContent = address;

  let rpcProvider = new ethers.JsonRpcProvider(FALLBACK_RPC, chainId);
  let provider, signer, writeContract;
  const readContract = () => new ethers.Contract(address, abi, rpcProvider);
  function ensureWriteContract() { if (!signer) throw new Error('Please connect wallet for write operations'); if (!writeContract) writeContract = new ethers.Contract(address, abi, signer); return writeContract; }

  $('btnConnect').onclick = async () => {
    try { if (!window.ethereum) return toast('MetaMask not found', 'error'); await loadAbi(); provider = new ethers.BrowserProvider(window.ethereum); await provider.send('eth_requestAccounts', []); const network = await provider.getNetwork(); if (Number(network.chainId) !== Number(chainId)) { toast(`Wrong network. Expected chainId ${chainId}, got ${network.chainId}`, 'error'); } signer = await provider.getSigner(); $('account').textContent = await signer.getAddress(); writeContract = new ethers.Contract(address, abi, signer); toast('Wallet connected'); } catch (e) { toast(e.message || 'Connect error', 'error'); }
  };

  $('btnInfo').onclick = async () => { const loader = $('loadingInfo'); show(loader, true); try { await loadAbi(); const c = readContract(); const info = await c.getContractInfo(); out('info', { name: info[0], version: info[1], totalFarms: info[2].toString(), totalProducts: info[3].toString(), owner: info[4] }); toast('Fetched contract info'); } catch (e) { out('info', e.message); toast('Failed to fetch info', 'error'); } finally { show(loader, false); } };

  $('btnAllFarms').onclick = async () => { const loader = $('loadingAllFarms'); show(loader, true); $('listFarms').innerHTML = ''; try { await loadAbi(); const farms = await readContract().getAllFarms(); renderFarms(farms); out('output', farms.map(f => ({ farmCode: f.farmCode, nameFarm: f.nameFarm, userId: f.userId, area: f.area.toString(), isActive: f.isActive }))); toast(`Loaded ${farms.length} farms`); } catch (e) { out('output', e.message); toast('Failed to fetch farms', 'error'); } finally { show(loader, false); } };

  function renderFarms(farms) {
    const container = $('listFarms');
    if (!farms || farms.length === 0) { container.innerHTML = '<div class="row">No farms found.</div>'; return; }
    container.innerHTML='';
    const header = document.createElement('div');
    header.className = 'tr th';
    header.innerHTML = '<div>Farm Code</div><div>Name</div><div>User</div><div>Area</div><div>Active</div>';
    container.appendChild(header);
    farms.forEach(f => {
      const row = document.createElement('div');
      row.className = 'tr';
      const codeShort = f.farmCode && f.farmCode.length > 18 ? `${f.farmCode.slice(0,10)}…${f.farmCode.slice(-6)}` : f.farmCode;
      row.innerHTML = `<div class="cell mono">${codeShort} <button class="xs" data-copy="${f.farmCode}">Copy</button></div><div class="cell">${f.nameFarm}</div><div class="cell">${f.userId}</div><div class="cell">${f.area.toString()}</div><div class="cell">${f.isActive ? 'Yes' : 'No'}</div>`;
      container.appendChild(row);
    });
    container.querySelectorAll('button[data-copy]').forEach(btn => btn.addEventListener('click', async (e) => {
      const v = e.currentTarget.getAttribute('data-copy');
      try { await navigator.clipboard.writeText(v); toast('Copied'); } catch { toast('Copy failed','error'); }
    }));
  }

  $('btnFarmsByUser').onclick = async () => { try { await loadAbi(); const userId = $('inpUserId').value.trim(); const farms = await readContract().getFarmByUserId(userId); renderFarms(farms); out('output', farms); } catch (e) { out('output', e.message); toast('Failed', 'error'); } };
  $('btnFarm').onclick = async () => { try { await loadAbi(); const code = $('inpFarmCode').value.trim(); const f = await readContract().getFarm(code); renderFarms([f]); out('output', f); } catch (e) { out('output', e.message); toast('Failed', 'error'); } };
  $('btnProduct').onclick = async () => { try { await loadAbi(); const code = $('inpProductCode').value.trim(); const p = await readContract().getProduct(code); out('output', p); toast('Fetched product'); } catch (e) { out('output', e.message); toast('Failed', 'error'); } };
  $('btnProductsByFarm').onclick = async () => { try { await loadAbi(); const code = $('inpFarmCode2').value.trim(); const ps = await readContract().getProductByFarmCode(code); out('output', ps.map(p => ({ productCode: p.productCode, name: p.name }))); } catch (e) { out('output', e.message); toast('Failed', 'error'); } };
  $('btnTrace').onclick = async () => { try { await loadAbi(); const code = $('inpProductCode2').value.trim(); const t = await readContract().getCompleteProductTraceability(code); out('output', { product: t[0], farmingProcess: t[1], medicine: t[2], fertilizer: t[3], harvest: t[4], distribution: t[5] }); toast('Fetched traceability'); } catch (e) { out('output', e.message); toast('Failed', 'error'); } };

  $('btnRegisterFarm').onclick = async () => { const loader = $('loadingWrite'); show(loader, true); try { await loadAbi(); const rf = { farmCode: $('rf_farmCode').value.trim(), fullname: $('rf_fullname').value.trim(), nameFarm: $('rf_nameFarm').value.trim(), userId: $('rf_userId').value.trim(), email: $('rf_email').value.trim(), phone: $('rf_phone').value.trim(), description: $('rf_description').value.trim(), location: $('rf_location').value.trim(), area: BigInt($('rf_area').value || '0'), images: $('rf_images').value.split(',').map(s => s.trim()).filter(Boolean) }; const c = ensureWriteContract(); const tx = await c.registerFarm(rf.farmCode, rf.fullname, rf.nameFarm, rf.userId, rf.email, rf.phone, rf.description, rf.location, rf.area, rf.images); out('writeOutput', `tx: ${tx.hash}`); const rc = await tx.wait(); out('writeOutput', { tx: tx.hash, status: rc.status }); toast('Farm registered'); } catch (e) { out('writeOutput', e.message); toast('Submit failed', 'error'); } finally { show(loader, false); } };

  $('btnAddProduct').onclick = async () => { const loader = $('loadingAddProduct'); show(loader, true); try { await loadAbi(); const data = { farmCode: $('ap_farmCode').value.trim(), productCode: $('ap_productCode').value.trim(), categoryName: $('ap_categoryName').value.trim(), name: $('ap_name').value.trim(), quantity: $('ap_quantity').value.trim(), price: $('ap_price').value.trim(), description: $('ap_description').value.trim(), image: $('ap_image').value.trim(), batchCode: $('ap_batchCode').value.trim(), certification: $('ap_certification').value.trim(), certificationLevel: Number($('ap_certLevel').value) }; const tx = await ensureWriteContract().addProduct(data); out('addProductOutput', `tx: ${tx.hash}`); const rc = await tx.wait(); out('addProductOutput', { tx: tx.hash, status: rc.status }); toast('Product added'); } catch (e) { out('addProductOutput', e.message); toast('Add product failed', 'error'); } finally { show(loader, false); } };

  $('btnAddFarming').onclick = async () => { try { await loadAbi(); const tx = await ensureWriteContract().addFarmingProcess($('fp_productCode').value.trim(), $('fp_nameProcess').value.trim(), $('fp_source').value.trim(), $('fp_plantingDate').value.trim(), $('fp_sowingDate').value.trim()); await tx.wait(); out('processOutput', 'Farming process added'); toast('Farming process added'); } catch (e) { out('processOutput', e.message); toast('Failed', 'error'); } };
  $('btnAddMedicine').onclick = async () => { try { await loadAbi(); const tx = await ensureWriteContract().addMedicine($('md_productCode').value.trim(), $('md_nameMedicine').value.trim(), $('md_quantityMedicine').value.trim(), $('md_medicineDate').value.trim(), $('md_medicineType').value.trim(), $('md_applicationMethod').value.trim()); await tx.wait(); out('processOutput', 'Medicine added'); toast('Medicine added'); } catch (e) { out('processOutput', e.message); toast('Failed', 'error'); } };
  $('btnAddFertilizer').onclick = async () => { try { await loadAbi(); const tx = await ensureWriteContract().addFertilizer($('fz_productCode').value.trim(), $('fz_nameFertilizer').value.trim(), $('fz_quantityFertilizer').value.trim(), $('fz_fertilizerDate').value.trim(), $('fz_fertilizerType').value.trim(), $('fz_applicationMethod').value.trim(), $('fz_expectedEffect').value.trim()); await tx.wait(); out('processOutput', 'Fertilizer added'); toast('Fertilizer added'); } catch (e) { out('processOutput', e.message); toast('Failed', 'error'); } };
  $('btnAddHarvest').onclick = async () => { try { await loadAbi(); const tx = await ensureWriteContract().addHarvest($('hv_productCode').value.trim(), $('hv_harvestDate').value.trim(), $('hv_estimatedQuantity').value.trim(), $('hv_actualQuantity').value.trim(), $('hv_quality').value.trim(), $('hv_harvestMethod').value.trim()); await tx.wait(); out('processOutput', 'Harvest added'); toast('Harvest added'); } catch (e) { out('processOutput', e.message); toast('Failed', 'error'); } };
  $('btnAddDistribution').onclick = async () => { try { await loadAbi(); const tx = await ensureWriteContract().addDistribution($('ds_productCode').value.trim(), $('ds_distributorName').value.trim(), $('ds_distributorPartner').value.trim(), $('ds_distributionDate').value.trim(), $('ds_transportMethod').value.trim(), $('ds_storageConditions').value.trim()); await tx.wait(); out('processOutput', 'Distribution added'); toast('Distribution added'); } catch (e) { out('processOutput', e.message); toast('Failed', 'error'); } };
})();
