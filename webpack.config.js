const path = require('path');
const glob = require('glob');
const outputDir = path.join(__dirname, 'dist/');

const isProd = process.env.NODE_ENV === 'production';

const reFiles = glob.sync(path.resolve(__dirname, "src", "**.bs.js")).reduce(function (obj, el) {
  obj[path.parse(el).name] = el;
  return obj;
}, {})

module.exports = {
    mode: isProd ? 'production' : 'development',
    entry: reFiles,
    output: {
        path: outputDir,
        filename: '[name].js',
        publicPath: '/',
    },
    plugins: [],
    module: {
        rules: [],
    },
};
