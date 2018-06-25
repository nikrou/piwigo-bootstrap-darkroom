const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const path = require('path');

const PORT = 8003;
const devMode = process.env.NODE_ENV !== 'production';

const TARGET_NAME = 'css';
const TARGET = path.join(__dirname, TARGET_NAME);
const PUBLIC_PATH = devMode ? `http://localhost:${PORT}/${TARGET_NAME}/` : `./${TARGET_NAME}/`;
const ASSETS_PUBLIC_PATH = devMode ? `http://localhost:${PORT}/${TARGET_NAME}/` : './';

const BOOTSWATCH_THEMES = [
    'cerulean',
    'cosmo',
    'cyborg',
    'darkly',
    'flatly',
    'journal',
    'litera',
    'lumen',
    'lux',
    'materia',
    'minty',
    'pulse',
    'sandstone',
    'simplex',
    'sketchy',
    'slate',
    'solar',
    'spacelab',
    'superhero',
    'united',
    'yeti'
];

const bootswatchEntries = BOOTSWATCH_THEMES.reduce((acc, name) => {
    acc[`bootswatch-${name}`] = `./scss/bootswatch/_${name}.scss`;

    return acc;
}, {});

const MATERIAL_THEMES = ['amber', 'blue', 'brown', 'darkroom', 'deep-orange', 'deep-purple', 'indigo', 'light-green', 'lime', 'purple', 'red', 'teal'];
const materialEntries = MATERIAL_THEMES.reduce((acc, name) => {
    acc[`material-${name}`] = `./scss/material/_${name}.scss`;

    return acc;
}, {});

module.exports = {
    devtool: 'source-map',

    entry: {
        theme: './scss/theme.scss',
        photoswipe: './scss/photoswipe.scss',
        slick: './scss/slick.scss',
        typeface: './scss/typeface.scss',
        'bootstrap-social': './scss/bootstrap-social.scss',
        'selectize-bootstrap': './scss/selectize-bootstrap.scss',
        'bootstrap-default': './scss/bootstrap-default.scss',
        'bootstrap-darkroom': './scss/bootstrap-darkroom.scss',
        ...bootswatchEntries,
        ...materialEntries
    },

    output: {
        path: TARGET,
        publicPath: PUBLIC_PATH
    },

    module: {
        rules: [
            {
                test: /\.scss$/,
                use: [
                    // fallback to style-loader in development
                    devMode ? 'style-loader' : MiniCssExtractPlugin.loader,
                    'css-loader',
                    'sass-loader'
                ]
            },

            {
                test: /\.(png|jpg|jpeg|gif|ico)$/,
                use: [
                    {
                        loader: 'file-loader',
                        options: {
                            name: 'images/[name].[ext]', // @TODO: find a way to inject [hash] in templates
                            publicPath: ASSETS_PUBLIC_PATH
                        }
                    }
                ]
            },

            {
                test: /\.(svg|ttf|otf|eot|woff(2)?)(\?[a-z0-9]+)?$/,
                use: [
                    {
                        loader: 'file-loader',
                        options: {
                            name: 'fonts/[name].[ext]', // @TODO: find a way to inject [hash:8] in templates
                            publicPath: ASSETS_PUBLIC_PATH
                        }
                    }
                ]
            }
        ]
    },

    plugins: [
        new MiniCssExtractPlugin({
            // Options similar to the same options in webpackOptions.output
            // both options are optional
            filename: devMode ? '[name].css' : '[name].css', // @TODO: find a way to inject [hash] in templates
            chunkFilename: devMode ? '[id].css' : '[id].css' // @TODO: find a way to inject [hash] in templates
        }),
        new CleanWebpackPlugin(`./${TARGET_NAME}`)
    ]
};
