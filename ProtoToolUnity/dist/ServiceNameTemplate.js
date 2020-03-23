define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const fs = nodeRequire("fs");
    const regValue = /(([a-zA-Z_0-9]+)\s*:\s*".*?"),?/g;
    /**
     * 服务端前缀
     */
    const serverPrefix = "export = {\n";
    /**
     * 客户端前缀
     */
    const clientPrefix = "const ServiceName = {\n";
    /**
     * 用于创建服务名字的常量文件
     *
     * @export
     * @class ServiceNameTemplate
     */
    class ServiceNameTemplate {
        addToFile(file, serviceName, isServer) {
            let valueDic = new Map();
            if (!fs.existsSync(file) || !fs.statSync(file).isFile()) {
                return this.addContent(serviceName, valueDic, isServer);
            }
            let content = fs.readFileSync(file, "utf8");
            regValue.lastIndex = 0;
            while (true) {
                let res = regValue.exec(content);
                if (res) {
                    valueDic.set(res[2], res[1]);
                }
                else {
                    break;
                }
            }
            return this.addContent(serviceName, valueDic, isServer);
        }
        addContent(serviceName, valueDic, isServer) {
            // let added = false;
            let code = isServer ? serverPrefix : clientPrefix;
            let arr = [];
            arr.push([serviceName, `\t${serviceName}: "${serviceName}"`]);
            for (let k of valueDic.keys()) {
                if (k != serviceName) {
                    arr.push([k, "\t" + valueDic.get(k)]);
                    // added = true;
                }
            }
            //附加字典中的内容
            // if (added) {
            // }
            arr.sort((a, b) => a > b ? 1 : -1);
            arr.map((item, idx) => arr[idx] = item[1]);
            code += arr.join(",\n");
            code += "\n}";
            return code;
        }
    }
    exports.default = ServiceNameTemplate;
});
//# sourceMappingURL=ServiceNameTemplate.js.map