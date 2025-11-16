from src.__project__.main import greet

def test_greet():
    assert greet() == "Hello from src.__project__!"