
let project = new Project('animals');
project.addAssets('Assets/**');
project.addShaders('Shaders/**');
project.addSources('Sources');

project.addLibrary('iron');
project.addLibrary('kha2d');
project.addLibrary('zui');

const android = project.targetOptions.android_native;
android.package = 'sh.now.sanva.lab.animals';

resolve(project);
