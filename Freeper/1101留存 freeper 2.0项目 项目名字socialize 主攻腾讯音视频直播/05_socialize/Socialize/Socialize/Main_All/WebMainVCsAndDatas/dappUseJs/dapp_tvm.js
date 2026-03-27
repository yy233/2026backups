(async () => {
    let network = await window.ethereum.request({method: "getCurrentNetwork", params: [undefined]})
    if (!network) return {}
    let rpcUrl = network.useNode
    let hp = new TronWeb.providers.HttpProvider(rpcUrl.endsWith('/jsonrpc')
        ? rpcUrl.substring(0, rpcUrl.length - 8)
        : rpcUrl);
    let tronWeb = new TronWeb(hp, hp, hp);

    function sign(data) {
        // let data = arguments[0];
        let param = data?.raw_data.contract[0].parameter.value;
        return window.ethereum.request({
            method: 'tronTransactionSign',
            params: [{
                from: tronWeb.address.fromHex(param.owner_address),
                to: tronWeb.address.fromHex(param.to_address || param.contract_address),
                value: param.amount || 0,
                data: param.data,
                raw: data,
            }]
        });
    }

    // 重写其签名方法
    tronWeb.trx.sign = (data) => sign.call(this, data)
    window.tronWeb = tronWeb;
        tronWeb.defaultAddress.base58 = network.address
        tronWeb.defaultAddress.hex = `0x${tronWeb.address.toHex(network.address).substring(2)}`;
    console.log('tron over!')
})()
