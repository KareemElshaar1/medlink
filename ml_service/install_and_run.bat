@echo off
echo MedLink ML Service Setup
echo ========================
echo.

echo Installing required packages...
pip install -r requirements.txt

echo.
echo Training advanced model...
python advanced_model.py

echo.
echo Starting server...
start /B python start_server.py

echo.
echo Server started! You can now run the Flutter app with:
echo flutter run -d chrome

echo.
echo Installation complete!
echo.
echo To train the model with the MIMIC-III dataset, run:
echo    python train_model.py
echo.
echo To start the prediction API server, run:
echo    python api.py
echo.
echo Press any key to exit...
pause > nul 